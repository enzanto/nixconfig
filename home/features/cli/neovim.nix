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
            viAlias = true;
            vimAlias = true;
            extraConfig = ''
                set number relativenumber autoindent tabstop=4 shiftwidth=4 mouse=a 
                filetype plugin indent on
                syntax enable
                noremap <C-e> :NERDTreeToggle <CR>
                noremap <C-s> :w <CR>
                let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips']
                let g:UltiSnipsExpandTrigger       = '<Tab>'   
                let g:UltiSnipsJumpForwardTrigger  = '<Tab>'    
                let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
              '';
            plugins = with pkgs.vimPlugins; [
                vimtex
                nerdtree
                #vim-snippets
                vim-airline
                ultisnips
                nvim-lspconfig
                nvim-cmp
                cmp-nvim-lsp
                cmp-buffer
                gruvbox-nvim
            ];
        };
    };
}