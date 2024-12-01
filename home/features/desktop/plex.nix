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
        programs.plex-desktop {
            enable = true;
        }
        };
}
