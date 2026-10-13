{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  cfg = config.features.desktop.sway;
  hostConfigPath = ./swayConfig + "/${osConfig.networking.hostName}.nix";
  hostConfig =
    if builtins.pathExists hostConfigPath
    then import hostConfigPath {inherit lib;}
    else {};

  mod = "Mod4";
  # sway itself comes from the NixOS module (programs.sway), see package = null below
  swaymsg = "${osConfig.programs.sway.package}/bin/swaymsg";
  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  # The 30s grace period from programs.swaylock is only meant for the idle lock
  swaylockNoGrace = "${swaylock} -f --grace 0";
  grimshot = getExe pkgs.sway-contrib.grimshot;

  # Wrapped in scripts so sway doesn't parse the pipes/$() itself
  screenshotOutput = pkgs.writeShellScript "screenshot-output" ''
    dir="''${XDG_PICTURES_DIR:-$HOME/Pictures}/screenshots"
    mkdir -p "$dir"
    ${grimshot} save output "$dir/$(date +%Y-%m-%d_%H-%M-%S).png"
  '';
  screenshotWindow = pkgs.writeShellScript "screenshot-window" ''
    ${grimshot} save active - | ${getExe pkgs.satty} --filename -
  '';
  screenshotRegionEdit = pkgs.writeShellScript "screenshot-region-edit" ''
    ${grimshot} save area - | ${getExe pkgs.swappy} -f -
  '';

  # Waybar runs from sway's startup with its own config while hyprland.nix still owns
  # programs.waybar. Once Hyprland is removed, move this to programs.waybar + systemd.
  waybarSettings = (import ./waybar/default.nix {wm = "sway";}).programs.waybar.settings;
  waybarConfig = pkgs.writeText "waybar-sway.json" (builtins.toJSON (attrValues waybarSettings));
  waybarCmd = "${getExe pkgs.waybar} -c ${waybarConfig} -s ${./waybar/style.css}";

  workspaceBinds = listToAttrs (concatMap (n: let
    key = toString (lib.mod n 10);
    ws = toString n;
  in [
    (nameValuePair "${mod}+${key}" "workspace number ${ws}")
    (nameValuePair "${mod}+Shift+${key}" "move container to workspace number ${ws}")
  ]) (range 1 10));
in {
  options.features.desktop.sway.enable = mkEnableOption "enable sway";

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      # Use the sway (or swayfx) from programs.sway in the NixOS config. That also means
      # session env vars / --unsupported-gpu belong there, not in extraSessionCommands here.
      package = null;
      checkConfig = false; # requires a package, and would reject swayfx-only keywords
      systemd.enable = true; # sway-session.target, used by swayidle and wpaperd

      config = {
        modifier = mod;
        terminal = "alacritty";
        menu = "rofi -show drun";
        bars = []; # waybar is started below; without this a default swaybar appears

        gaps = {
          inner = 5;
          outer = 10;
        };
        window = {
          titlebar = false;
          border = 2;
        };
        floating.titlebar = false;
        focus.newWindow = "focus"; # was misc.focus_on_activate

        input = {
          "type:keyboard".xkb_layout = "no";
          "type:touchpad" = {
            natural_scroll = "enabled";
            tap = "enabled";
          };
        };

        output = hostConfig.output or {};
        workspaceOutputAssign = hostConfig.workspaceOutputAssign or [];

        # Hyprland only did this when launched via $mod+m ([workspace 5 silent])
        assigns."5" = [{app_id = "^(thunderbird|net\\.thunderbird\\.Thunderbird)$";}];

        startup =
          [
            {command = waybarCmd;}
            # Lock right away, getty autologins on tty1 (was hyprlock-init.conf)
            {command = swaylockNoGrace;}
          ]
          ++ (hostConfig.startup or []);

        # Replaces the HM defaults entirely ($mod+l etc. would otherwise be vim-style focus)
        keybindings =
          {
            "${mod}+f" = "exec firefox";
            "${mod}+Shift+f" = "workspace number 6; exec firefox -P Noroff";
            "${mod}+t" = "exec alacritty";
            "${mod}+m" = "exec thunderbird";
            # Rofi shortcuts
            "${mod}+Return" = "exec rofi -show drun";
            "${mod}+Shift+e" = "exec rofi -show emoji";
            "${mod}+Shift+t" = "exec rofi -show top";
            "${mod}+Shift+c" = "exec rofi -show calc";
            # change opacity
            "${mod}+o" = "opacity 1";

            "${mod}+l" = "exec ${swaylockNoGrace}";
            "${mod}+q" = "kill";
            "${mod}+c" = "exec code";
            "${mod}+e" = "exec thunar";
            "${mod}+p" = "exec waypaper --folder /home/fredrik/Pictures/wallpapers";

            "${mod}+Left" = "focus left";
            "${mod}+Right" = "focus right";
            "${mod}+Up" = "focus up";
            "${mod}+Down" = "focus down";
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Right" = "move right";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Down" = "move down";

            "${mod}+Ctrl+Left" = "workspace prev_on_output";
            "${mod}+Ctrl+Right" = "workspace next_on_output";
            "${mod}+Shift+Ctrl+Left" = "move container to workspace prev_on_output";
            "${mod}+Shift+Ctrl+Right" = "move container to workspace next_on_output";

            # Not bound under Hyprland, but needed in sway
            "${mod}+space" = "floating toggle";
            "${mod}+Shift+space" = "fullscreen toggle";
            "${mod}+r" = "mode resize";
            "${mod}+Shift+r" = "reload";
            "${mod}+b" = "splith";
            "${mod}+v" = "splitv";
            "${mod}+w" = "layout toggle split tabbed";
            "${mod}+minus" = "scratchpad show";
            "${mod}+Shift+minus" = "move scratchpad";

            # Screenshots
            "Print" = "exec ${screenshotOutput}";
            "Shift+Print" = "exec ${screenshotWindow}";
            "${mod}+Shift+Print" = "exec ${grimshot} copy area";
            "Alt+Print" = "exec ${screenshotRegionEdit}";
          }
          // workspaceBinds;
      };

      extraConfig =
        ''
          bindsym --locked XF86AudioRaiseVolume exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
          bindsym --locked XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          bindsym --locked XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bindsym --locked XF86AudioMicMute exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
          bindsym --locked XF86MonBrightnessUp exec brightnessctl s 10%+
          bindsym --locked XF86MonBrightnessDown exec brightnessctl s 10%-

          # Same as active_opacity/inactive_opacity = 0.85
          for_window [app_id=".*"] opacity 0.85
          for_window [class=".*"] opacity 0.85
        ''
        + optionalString (hasPrefix "swayfx" (getName osConfig.programs.sway.package)) ''

          # swayfx only
          blur enable
          blur_passes 2
          blur_radius 2
        ''
        + (hostConfig.extraConfig or "");
    };

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        image = "/home/fredrik/Pictures/wallpapers/anime_girl_alone_5k-1366x768.jpg";
        scaling = "fill";
        effect-blur = "5x3";
        grace = 30;
        fade-in = 0.2;
        indicator-radius = 100;
        indicator-thickness = 5;
        inside-color = "5b6078";
        ring-color = "181926";
        text-color = "cad3f5";
        key-hl-color = "cad3f5";
        line-color = "00000000";
        separator-color = "00000000";
      };
    };

    services.swayidle = {
      enable = true;
      systemdTargets = ["sway-session.target"];
      events = {
        before-sleep = swaylockNoGrace;
        lock = swaylockNoGrace;
      };
      timeouts = [
        {
          timeout = 300;
          command = "${swaylock} -f";
        }
        {
          timeout = 600;
          command = "${swaymsg} 'output * power off'";
          resumeCommand = "${swaymsg} 'output * power on'";
        }
      ];
    };

    services.wpaperd = mkIf (hostConfig ? wpaperd) {
      enable = true;
      settings = hostConfig.wpaperd;
    };
    # The HM unit is WantedBy graphical-session.target, which would also start it under Hyprland
    systemd.user.services.wpaperd = mkIf (hostConfig ? wpaperd) {
      Install.WantedBy = mkForce ["sway-session.target"];
      Unit.PartOf = mkForce ["sway-session.target"];
      Unit.After = mkForce ["sway-session.target"];
    };

    home.packages = with pkgs; [
      sway-contrib.grimshot
      wl-clipboard
    ];
  };
}
