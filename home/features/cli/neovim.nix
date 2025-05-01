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
            extraLuaConfig = ''
                vim.opt.number = true
                vim.opt.relativenumber = true
                vim.opt.autoindent = true
                vim.opt.tabstop = 4
                vim.opt.shiftwidth = 4
                vim.opt.mouse = "a"
                vim.opt.spell = true
                vim.opt.spelllang = "en_us"

                vim.keymap.set('n', '<C-e>', ':NERDTreeToggle<CR>')
                vim.keymap.set('n', '<C-s>', ':w<CR>')

                vim.g.UltiSnipsSnippetDirectories = { vim.env.HOME .. '/.config/nvim/UltiSnips' }
                vim.g.UltiSnipsExpandTrigger = '<Tab>'
                vim.g.UltiSnipsJumpForwardTrigger = '<Tab>'
                vim.g.UltiSnipsJumpBackwardTrigger = '<S-Tab>'
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