{
    config,
    lib,
    pkgs,
    inputs,
    ...
}:
with lib; let
    cfg = config.features.desktop.hyprland;
in {
    options.features.desktop.hyprland.enable = mkEnableOption "enable hyprland";

    config = mkIf cfg.enable {
		wayland.windowManager.hyprland = {
		enable = true;
        xwayland.enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        extraConfig = ''
            # Environment variables for Hyprland configuration
            env = GBM_BACKEND,nvidia-drm           # Use NVIDIA GBM backend
            env = WLR_DRM_NO_ATOMIC,1              # Disable atomic mode setting for wlroots
            env = WLR_NO_HARDWARE_CURSORS,1        # Disable hardware cursors
            env = LIBVA_DRIVER_NAME,nvidia         # Set VAAPI driver to NVIDIA
            env = __GLX_VENDOR_LIBRARY_NAME,nvidia  # Set GLX vendor library to NVIDIA
            env = __GL_GSYNC_ALLOWED,1             # Enable GSync for NVIDIA
            env = NVD_BACKEND,direct               # Enable direct mode for NVIDIA
            cursor {
            no_hardware_cursors = true
            }
            exec-once = waybar
            '';
        settings = {
            "$mod" = "SUPER";
            exec-once = [
                "waybar &"
                "hyprpaper &"
                "hypridle &"
            ];
            monitor = [
                "HDMI-A-1,1920x1080,-1080x-138,1,transform,1"
                "DP-2,2560x1440@143.91,0x0,1"
                "HDMI-A-2, 1920x1080,2560x250,1"
            ];
            bind = [
                "$mod, F, exec, firefox"
                "$mod, t, exec, kitty"
                "$mod, RETURN, exec, wofi"
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



            ];
            input = {
                kb_layout="no";
            };
        };
		};
        home.packages = with pkgs; [
            kitty
            hypridle
            hyprlock
            hyprpaper
            hyprshot
            waybar
            waypaper
            wofi
        ];
    };	
}
