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
    # hostConfigPath = ./hyprConfig + "/razorcrest.nix";  # <-- Use the `hostname` argument directly
    hostConfigPath = ./hyprConfig + "/${osConfig.networking.hostName}.nix";  # <-- Use the `hostname` argument directly
    hostConfig = if builtins.pathExists hostConfigPath then import hostConfigPath else {};
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
            "$menu" = "wofi --show drun";
            exec-once = [
                "waybar &"
                #"hyprpaper &"
                "hypridle &"
            ];
            monitor = hostConfig.monitor;# or "";
            # monitor = [
            #     "eDP-1, 1920x1080,0x0,1"
            # ];

            bind = [
                "$mod, F, exec, firefox"
                "$mod, t, exec, kitty"
                "$mod, RETURN, exec, $menu"
                "$mod, Q, killactive"
                "$mod, c, exec, code"
                "$mod, p, exec waypaper --folder /home/fredrik/Pictures/wallpapers" #needs more setup!
                "$mod, left, movefocus, l "                                         # Focus left window
                "$mod, right, movefocus, r"                                         # Focus right window
                "$mod, up, movefocus, u   "                                         # Focus window above
                "$mod, down, movefocus, d "                                         # Focus window below
                "$mod SHIFT, left, movewindow, l "                       # Move window left
                "$mod SHIFT, right, movewindow, r"                       # Move window right
                "$mod SHIFT, up, movewindow, u   "                       # Move window up
                "$mod SHIFT, down, movewindow, d "                       # Move window down

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

                # Screenshots
                ", Print, exec, ${lib.getExe pkgs.hyprshot} --mode output -o $XDG_PICTURES_DIR/screenshots"# --raw | ${lib.getExe pkgs.satty} --filename -"
                "SHIFT, Print, exec, ${lib.getExe pkgs.hyprshot} --mode window --raw | ${lib.getExe pkgs.satty} --filename -"
                "$mod SHIFT, Print, exec, ${lib.getExe pkgs.hyprshot} -m region --clipboard-only"
                "ALT, Print, exec, ${lib.getExe pkgs.hyprshot} --mode region --raw | ${lib.getExe pkgs.satty} --filename -"



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
                kb_layout="no";
                touchpad = {
                    natural_scroll = true;
                };
            };
            gestures = {
                workspace_swipe = true;
                workspace_swipe_min_fingers = true;
            };
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
            waypaper
            #waybar
            wofi
        ];
            programs.waybar = waybarConf.programs.waybar;# {
    #   enable = true;
    #   systemd.enable = true;

      #settings = waybarConf.settings; 

      #style = waybarStyle.style;
    # };
  };
        }

