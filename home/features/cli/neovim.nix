{
    config,
    lib,
    pkgs,
    ...
}:
with lib; let
    cfg = config.features.cli.neovim;
in {
    options.features.cli.neovim.enable = mkEnableOption "Enables neovim";

    config = mkIf cfg.enable {
        programs.neovim = {
            enable = true;
            defaultEditor = true;
            viAlial = true;
            vimAlias = true;
            extraConfig = ''
              set number relativenumber autoindent tabstop=4 shiftwidth=4 mouse=a
              '';
            plugins = with pkgs.vimPlugins; [
                vimtex
                nerdtree
            ];
        };
    };
}