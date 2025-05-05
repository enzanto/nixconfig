{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.nixvim;
in {
  options.features.cli.nixvim.enable = mkEnableOption "Enables nixvim";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      alejandra
    ];
    programs.nixvim = {
      enable = true;
      colorschemes.gruvbox.enable = true;
      # colorschemes.catppuccin.enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      # extraConfig = ''
      #     noremap <C-e> :NERDTreeToggle <CR>
      #     let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips']
      #     let g:UltiSnipsExpandTrigger       = '<Tab>'
      #     let g:UltiSnipsJumpForwardTrigger  = '<Tab>'
      #     let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
      #   '';
      globals.mapleader = " ";
      globals.maplocalleader = " ";
      opts = {
        number = true;
        relativenumber = true;
        autoindent = true;
        tabstop = 4;
        shiftwidth = 4;
        mouse = "a";
        spell = true;
      };
      keymaps = [
        {
          # writing file
          action = "<cmd>:w<cr>";
          key = "<leader>w";
        }
        {
          # comment toggle
          action = ":CommentToggle<cr>";
          key = "<leader>c";
        }
        {
          # tree toggle
          action = "<cmd>:NvimTreeToggle<cr>";
          key = "<leader>e";
        }
        {
          # stage hunk
          action = "<cmd>:Gitsigns stage_hunk<cr>";
          key = "<leader>hs";
        }
      ];
      plugins = {
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings.sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
          ];
        };
        conform-nvim = {
          enable = true;
          settings = {
            format_on_save = {
              lspFallback = true;
              timeoutMs = 500;
            };
            notify_on_error = true;
            formatters_by_ft = {
              nix = ["alejandra"];
            };
          };
        };
        fugitive.enable = true;
        gitsigns.enable = true;
        lsp = {
          enable = true;
          servers = {
            lua-ls.enable = true;
            pylsp.enable = true;
            nixd.enable = true;
            texlab.enable = true;
          };
        };
        lualine.enable = true;
        nvim-autopairs.enable = true;
        nvim-tree = {
          enable = true;
          actions.openFile.quitOnOpen = true;
        };
        rainbow-delimiters.enable = true;
        treesitter = {
          enable = true;
          folding = true;
          # settings.indent = true;
          settings.highlight.enable = true;
        };
        telescope.enable = true;
        treesitter-textobjects.enable = true;
        vimtex = {
          enable = true;
          texlivePackage = pkgs.texlive.combined.scheme-full;
        };
      };
      extraPlugins = with pkgs.vimPlugins; [
        {
          # nvim comment with config
          plugin = nvim-comment;
          config = ''lua require("nvim_comment").setup()'';
        }
        {
          #semshi python highlighter
          plugin = pkgs.fetchFromGitHub {
            owner = "wookayin";
            repo = "semshi";
            rev = "v0.3.0";
            sha256 = "sha256-gQy8rQBTzODp8OfnHdggxSq275/9T8feJAkWzH+CdvU=";
          };
        }
        UltiSnips
      ];
    };
  };
}
