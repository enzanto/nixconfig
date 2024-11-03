{
    config,
    lib,
    pkgs,
    ...
}:
with lib; let
    cfg = config.features.desktop.vscode;
in {
    options.features.desktop.vscode.enable = mkEnableOption "enable vscode";

    config = mkIf cfg.enable {
        programs.vscode = {
            enable = true;
            extensions = with pkgs.vscode-extensions; [
                vscodevim.vim
                bbenoist.nix
                samuelcolvin.jinjahtml
                oderwat.indent-rainbow
            ];
        };
    };
}
