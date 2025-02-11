{
    config,
    lib,
    pkgs,
    inputs,
    ...
}:
with lib; let
    cfg = config.features.desktop.hyprland;
    hostname = builtins.getEnv "HOSTNAME";
    hostConfigPath = ./hyprConfig + "/${hostname}.nix";
    hostConfig = if builtins.pathExists hostConfigPath then import hostConfigPath else {};
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
            exec-once = [
                "waybar &"
                "hyprpaper &"
                "hypridle &"
            ];
            monitor = hostConfig.monitor or [];
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
