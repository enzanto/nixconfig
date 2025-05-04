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
          action = "<cmd>:w<cr>";
          key = "<leader>w";
        }
        {
          action = ":CommentToggle<cr>";
          key = "<leader>c";
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
		treesitter = {
		enable = true;
		folding = true;
		# settings.indent = true;
		settings.highlight.enable = true;
		};
		treesitter-textobjects.enable = true;
        vimtex.enable = true;
      };
      extraPlugins = with pkgs.vimPlugins; [
        { # nvim comment with config
          plugin = nvim-comment;
          config = ''lua require("nvim_comment").setup()'';
        }
		{ #semshi python highlighter
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
