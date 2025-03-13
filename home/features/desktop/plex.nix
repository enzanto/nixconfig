{
    config,
    lib,
    pkgs,
    ...
}:
with lib; let
    cfg = config.features.desktop.plex;
in {
    options.features.desktop.plex.enable = mkEnableOption "enable plex";

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            plex-desktop
        ];
        xdg.portal.enable = true;
        xdg.portal.xdgOpenUsePortal = true;
        xdg.portal.configPackages = [
            pkgs.gnome-session
        ];
        xdg.portal.extraPortals = [
            pkgs.kdePackages.xdg-desktop-portal-kde
            pkgs.xdg-desktop-portal-gtk
        ];
        };
}
