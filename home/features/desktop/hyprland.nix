{
    config,
    lib,
    pkgs,
    ...
}:
with lib; let
    cfg = config.features.desktop.hyprland;
in {
    options.features.desktop.hyprland.enable = mkEnableOption "enable hyprland";

    config = mkIf cfg.enable {
		wayland.windowManager.hyprland = {
		enable = true;
		};
    };	
}
