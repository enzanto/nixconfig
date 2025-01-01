{
    config,
    lib,
    pkgs,
    ...
}:
with lib; let
    cfg = config.features.desktop.latex;
in {
    options.features.desktop.latex.enable = mkEnableOption "enable latex";

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            texliveFull
        ];

        };
}

