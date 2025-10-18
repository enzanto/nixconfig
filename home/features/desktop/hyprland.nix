{
  config,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprland;
  # hostConfigPath = ./hyprConfig/coruscant.nix; # <-- Use the `hostname` argument directly
  hostConfigPath = ./hyprConfig + "/${osConfig.networking.hostName}.nix"; # <-- Use the `hostname` argument directly
  hostConfig =
    if builtins.pathExists hostConfigPath
    then import hostConfigPath
    else {};
  waybarConf = import ./waybar/default.nix;
in {
  options.features.desktop.hyprland.enable = mkEnableOption "enable hyprland";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      extraConfig = hostConfig.extraConfig or "";
      settings = {
        "$mod" = "SUPER";
        "$menu" = "rofi -show drun";
        decoration = {
          active_opacity = 0.85;
          inactive_opacity = 0.85;
          blur = {
            enabled = true;
            size = 2;
            passes = 2;
          };
        };
        exec-once = [
          "waybar &"
          "hyprpaper &"
          "hyprlock -c /home/fredrik/.config/hypr/hyprlock-init.conf &"
          # "hypridle &"
          "xrandr --output DP-2 --primary"
        ];
        general = {
          layout = "master";
        };
        master = {
          mfact = 0.70;
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          focus_on_activate = true;
        };
        monitor = hostConfig.monitor; # or "";
        # monitor = [
        #     "eDP-1, 1920x1080,0x0,1"
        # ];
        workspace = hostConfig.workspace; # or "";

        bind = [
          "$mod, F, exec, firefox"
          "$mod SHIFT, F, exec, [workspace 6] firefox -P Noroff"
          "$mod, t, exec, konsole"
          "$mod, m, exec, [workspace 5 silent] thunderbird"
          # Rofi shortcuts
          "$mod, RETURN, exec, $menu"
          "$mod shift, E, exec, rofi -show emoji"
          "$mod shift, T, exec, rofi -show top"
          "$mod shift, C, exec, rofi -show calc"
          # "ALT TAB, exec, rofi -show window"

          "$mod, L, exec, hyprlock"
          "$mod, Q, killactive"
          "$mod, c, exec, code"
          "$mod, e, exec, thunar"
          "$mod, p, exec, waypaper --folder /home/fredrik/Pictures/wallpapers" #needs more setup!
          "$mod, left, movefocus, l " # Focus left window
          "$mod, right, movefocus, r" # Focus right window
          "$mod, up, movefocus, u   " # Focus window above
          "$mod, down, movefocus, d " # Focus window below
          "$mod SHIFT, left, movewindow, l " # Move window left
          "$mod SHIFT, right, movewindow, r" # Move window right
          "$mod SHIFT, up, movewindow, u   " # Move window up
          "$mod SHIFT, down, movewindow, d " # Move window down

          #Switch workspaces with mod+ num
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"
          "$mod SHIFT CTRL, left, movetoworkspace, -1"
          "$mod SHIFT CTRL, right, movetoworkspace, +1"
          "$mod CTRL, left, workspace, -1"
          "$mod CTRL, right, workspace, +1"

          # Screenshots
          ", Print, exec, ${lib.getExe pkgs.hyprshot} full --mode output -o $XDG_PICTURES_DIR/screenshots" # --raw | ${lib.getExe pkgs.satty} --filename -"
          # "SHIFT, Print, exec, ${lib.getExe pkgs.hyprshot} --mode window --raw | ${lib.getExe pkgs.satty} --filename -"
          "SHIFT, Print, exec, active_win_id=$(hyprctl activewindow -j | jq '.id'); ${lib.getExe pkgs.hyprshot} --window $active_win_id --raw | ${lib.getExe pkgs.satty} --filename -"
          "$mod SHIFT, Print, exec, ${lib.getExe pkgs.hyprshot} -m region --clipboard-only"
          "ALT, Print, exec, ${lib.getExe pkgs.hyprshot} --mode region --raw | ${lib.getExe pkgs.swappy} -f -"
        ];
        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];
        input = {
          kb_layout = "no";
          touchpad = {
            natural_scroll = true;
          };
        };
        # gestures = {
        #   workspace_swipe = true;
        #   workspace_swipe_min_fingers = true;
        # };
      };
    };
    services = {
      hyprpaper = hostConfig.hyprpaper;
      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            before_sleep_cmd = "hyprlock -c /home/fredrik/.config/hypr/hyprlock-init.conf";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "hyprlock";
            }
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 30;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = "/home/fredrik/Pictures/wallpapers/anime_girl_alone_5k-1366x768.jpg";
            blur_passes = 3;
            blur_size = 5;
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -250";
            monitor = "";
            dots_center = true;
            fade_on_empty = true;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = "Password";
            shadow_passes = 2;
          }
        ];
      };
    };
    home.packages = with pkgs; [
      brightnessctl
      kitty
      hypridle
      hyprlock
      hyprpaper
      hyprshot
      satty
      swappy
      xfce.thunar
      waypaper
      #waybar
      rofi-bluetooth
      rofi-systemd
      # rofi-wayland
    ];
    programs.waybar = waybarConf.programs.waybar; # {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      extraConfig = {
        modi = "drun,run,window,calc";
        drun-display-format = "{icon} {name}";
        display-drun = "🕵 Application";
        show-icons = true;
      };
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
        rofi-power-menu
        rofi-top
        # rofi-bluetooth
      ];
      theme = "rounded-nord-dark";
    };
    #   enable = true;
    #   systemd.enable = true;

    #settings = waybarConf.settings;

    #style = waybarStyle.style;
    # };
  };
}
