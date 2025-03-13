{
    config,
    lib,
    pkgs,
    nixvim,
    ...
}:
with lib; let
    cfg = config.features.cli.nixvim;
in {
    options.features.cli.nixvim.enable = mkEnableOption "Enables nixvim";

    config = mkIf cfg.enable {
        programs.nixvim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            # extraConfig = ''
            #     set number relativenumber autoindent tabstop=4 shiftwidth=4 mouse=a 
            #     filetype plugin indent on
            #     syntax enable
            #     noremap <C-e> :NERDTreeToggle <CR>
            #     let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips']
            #     let g:UltiSnipsExpandTrigger       = '<Tab>'   
            #     let g:UltiSnipsJumpForwardTrigger  = '<Tab>'    
            #     let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
            #   '';
            # plugins = with pkgs.vimPlugins; [
            #     vimtex
            #     nerdtree
            #     #vim-snippets
            #     vim-airline
            #     #ultisnips
            #     nvim-lspconfig
            #     nvim-cmp
            #     cmp-nvim-lsp
            #     cmp-buffer
            #     gruvbox-nvim
            # ];
        };
    };
}