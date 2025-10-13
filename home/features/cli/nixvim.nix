{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.features.cli.nixvim;
  stablePkgs = inputs.nixpkgs-stable.legacyPackages.${pkgs.system};
in {
  options.features.cli.nixvim.enable = mkEnableOption "Enables nixvim";

  config =
    mkIf cfg.enable {
      home.packages = with pkgs; [
        alejandra
      ];
      programs.nixvim = {
        enable = true;
        clipboard.register = "unnamedplus";
        # colorschemes.gruvbox.enable = true;
        # colorschemes.catppuccin.enable = true;
        colorschemes.nord.enable = true;
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
          autoindent = true;
          conceallevel = 2;
          mouse = "a";
          number = true;
          relativenumber = true;
          shiftwidth = 4;
          spell = true;
          tabstop = 4;
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
          {
            action = "<cmd>Telescope find_files<cr>";
            key = "<leader>ff";
          }
          {
            action = "<cmd>Telescope live_grep<cr>";
            key = "<leader>lg";
          }
          {
            action = "<cmd>ObsidianSearch<cr>";
            key = "<leader>fo";
          }
        ];
        plugins = {
          cmp = {
            enable = true;
            autoEnableSources = true;
            settings.mapping = {
              "<C-n>" = "cmp.mapping.select_next_item()";
              "<C-space>" = "cmp.mapping.complete()";
              # "<tab>" = "cmp.mapping.confirm({ select = true })";
              # new mappinng test
              "<Tab>" = "cmp.mapping(function(fallback)
			  if require('luasnip').expand_or_jumpable() then
				return require('luasnip').expand_or_jump()
			  elseif require('cmp').visible() then
				return require('cmp').confirm({ select = true })
			  else
				return fallback()
			  end
			end, {'i', 's'})";
              #end of mapping test
            };
            settings.sources = [
              {name = "nvim_lsp";}
              {name = "path";}
              {name = "buffer";}
              {name = "luasnip";}
              {name = "spell";}
            ];
          };
          cmp-buffer.enable = true;
          cmp_luasnip.enable = true;
          cmp-nvim-lsp.enable = true;
          cmp-nvim-lua.enable = true;
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
          friendly-snippets.enable = true;
          fugitive.enable = true;
          gitsigns.enable = true;
          hardtime.enable = true;
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
          luasnip = {
            enable = true;
            fromLua = [{paths = ./snippets;}];
          };
          nvim-autopairs.enable = true;
          nvim-tree = {
            enable = true;
            actions.openFile.quitOnOpen = true;
          };
          obsidian = {
            enable = true;
            settings = {
              completion = {
                nvimCmp = true;
              };
              note_frontmatter_func = {
                __raw = ''
                             function(note)
                               if note.title then
                             	note:add_alias(note.title)
                               end

                               local git_author = vim.fn.system("git config user.name"):gsub("%s+$", "")

                               local out = {
                             	id = note.id,
                             	aliases = note.aliases,
                             	tags = note.tags,
                             	note_author = git_author,
                  title = note.title,
                               }

                               if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                             	for k, v in pairs(note.metadata) do
                             	  out[k] = v
                             	end
                               end

                               return out
                             end
                '';
              };
              note_id_func = {
                __raw = ''
                  function(title)

                    local suffix = ""
                    if title ~= nil then
                  	suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                    else
                  	for _ = 1, 4 do
                  	  suffix = suffix .. string.char(math.random(65, 90))
                  	end
                    end
                    return tostring(os.time()) .. "-" .. suffix
                  end

                '';
              };

              workspaces = [
                {
                  name = "Main";
                  path = "~/jottacloud/Obsidian/Main";
                }
              ];
            };
            #settings.dir = "~/jottacloud/Obsidian/Main";
          };
          rainbow-delimiters.enable = true;
          render-markdown.enable = true;
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
            texlivePackage = stablePkgs.texlive.combined.scheme-full;
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
          {
            plugin = pkgs.fetchFromGitHub {
              owner = "carlsmedstad";
              repo = "vim-bicep";
              rev = "8172cf773d52302d6c9d663487f56630302b2fda";
              sha256 = "ls3+V51l6xq16ZIf5N9THsQ/rIgK+OXovND8//avs/0=";
            };
          }
          UltiSnips
        ];
      };
    };
}
