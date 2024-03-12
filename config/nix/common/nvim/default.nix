{ pkgs, config, inputs, ... }: {
  imports = [ inputs.nixneovim.nixosModules.default ];
  programs.nixneovim = {
    enable = true;
    options = {
      foldexpr = "nvim_treesitter#foldexpr()";
      foldmethod = "expr";
      number = true;
      relativenumber = true;
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      hidden = true;
      smartcase = true;
      termguicolors = true;
      signcolumn = "yes";
      wrap = true;
      completeopt = "menu,menuone,popup,noselect";
      undodir = "${config.xdg.cacheHome}/undodir";
      undofile = true;
    };

    globals = { mapleader = " "; };
    plugins = {
      lspconfig = {
        enable = true;
        servers = {
          nil = {
            enable = true;
            extraConfig =
              /* lua */
              ''
                settings = {
                  ['nil'] = {
                    formatting = {
                      command = { "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" },
                    },
                    nix = {
                      flake = {
                          autoArchive = true,
                      },
                    },
                  },
                },
              '';
          };
          lua-language-server.enable = true;
          jsonls.enable = true;
          html.enable = true;
          pylyzer.enable = true;
          sqls = {
            enable = true;
            onAttachExtra =
              /* lua */
              ''
                require('sqls').on_attach(client, bufnr)
              '';
          };
          # rust-analyzer.enable = true;
        };
        extraLua.pre =
          # lua
          ''
            local lsp_zero = require'lsp-zero'
            local lspconfig = require 'lspconfig'
            lsp_zero.on_attach(function(client, bufnr)
              lsp_zero.default_keymaps({buffer = bufnr})
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(bufnr, true)
                end
            end)
          '';
        # extraLua.post = ''
        #   vim.lsp.inlay_hint.enable(bufnr, true)
        # '';
      };

      nvim-dap.enable = true;
      todo-comments.enable = true;
      lualine = { enable = true; };
      commentary.enable = true;
      surround.enable = true;
      which-key.enable = true;
      ufo.enable = true;
      fugitive.enable = true;
      markdown-preview = {
        enable = true;
        autoStart = true;
      };
      ts-context-commentstring.enable = true;

      treesitter = {
        enable = true;
        indent = true;
        folding = true;
        refactor = {
          smartRename = {
            enable = true;
            keymaps = { smartRename = "<leader>rn"; };
          };
        };
      };

      mini = {
        enable = true;
        ai.enable = true;
        # pairs.enable = true;
        # cursorword.enable = true;
        starter.enable = true;
      };

    };
    colorschemes = {
      catppuccin = {
        enable = true;
        flavour = "mocha";
      };
    };
    mappings = {
      normal = {
        "<leader>ff" = "require'telescope.builtin'.find_files";
        "<leader>gg" = "require'telescope.builtin'.live_grep";
        "<leader>;" = "require'telescope.builtin'.buffers";
        "<leader>o" = "[[<cmd>TroubleToggle<cr>]]";
        "<leader>ee" = "require'rest-nvim'.run";
        "<leader>ec" = "function() require'rest-nvim'.run(true) end";
        # "<leader>ee" = "[[<Plug>RestNvim]]";
        # "<leader>ec" = "[[<Plug>RestNvimPreview]]";
        # "<leader>el" = "require('telescope').extensions.rest.select_env";
        "<leader>\\\"" = ''[["+]]'';
        "vff" = "[[<cmd>vertical Gdiffsplit<cr>]]";
        "<C-k>" = "vim.lsp.buf.definition";
        "gi" = "vim.lsp.buf.implementation";
        "<leader>a" = "vim.lsp.buf.code_action";
        "F" = "function() vim.lsp.buf.format({ async = true }) end";
        "<leader><leader>" = "'<c-^>'";
        "<leader>q" = "[[<cmd>bw<cr>]]";
        "<leader>n" = "[[<cmd>bnext<cr>]]";
        "<leader>p" = "[[<cmd>bprev<cr>]]";

        "<C-l>" = "[[<cmd>Outline<cr>]]";
        "<C-\\\\>" = "require('FTerm').toggle";
      };
      terminal = {
        "<C-\\\\>" = "require('FTerm').toggle";
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      comfortable-motion
      vim-abolish
      telescope-nvim
      telescope-ui-select-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      telescope-dap-nvim
      rustaceanvim

      # Treesitter stuff
      outline-nvim

      # lsp stuff
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp_luasnip
      cmp-tmux
      cmp-treesitter
      luasnip
      fidget-nvim
      copilot-lua
      lsp-zero-nvim
      trouble-nvim
      crates-nvim
      sqls-nvim
      # (nvim-treesitter.withPlugins (_: nvim-treesitter.allGrammars ++ [
      #   (pkgs.tree-sitter.buildGrammar {
      #     language = "just";
      #     version = "8af0aab";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "IndianBoy42";
      #       repo = "tree-sitter-just";
      #       rev = "8af0aab79854aaf25b620a52c39485849922f766";
      #       sha256 = "sha256-hYKFidN3LHJg2NLM1EiJFki+0nqi1URnoLLPknUbFJY=";
      #     };
      #   })
      # ]))

      # No more postman
      rest-nvim

      # UI
      noice-nvim
      nvim-web-devicons

      # Utils
      FTerm-nvim
      plenary-nvim
      nix-develop-nvim

    ];
    extraConfigLua = /* lua */ ''
      require('rest-nvim').setup()
      require('telescope').setup {
          defaults = {
              initial_mode = 'insert',
          },
          extensions = {
              fzf = {
                  fuzzy = true,                   -- false will only do exact matching
                  override_generic_sorter = true, -- override the generic sorter
                  override_file_sorter = true,    -- override the file sorter
                  case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
              }
          }
      }

      require('telescope').load_extension("ui-select")
      require('telescope').load_extension("dap")
      require('telescope').load_extension("fzf")
      require('telescope').load_extension("file_browser")
      require('telescope').load_extension("rest")

      vim.g.rustaceanvim = {
          tools = {
              enable_clippy = false,
          },
          server = {
              capabilities = require 'lsp-zero'.get_capabilities(),
              on_attach = function(client, bufnr)
                  if client.server_capabilities.inlayHintProvider then
                      vim.lsp.inlay_hint.enable(bufnr, true)
                  end
              end,
          },
          dap = {
              autoload_configurations = false
          },
      }

      require("copilot").setup({
          suggestion = {
              enabled = true,
              auto_trigger = true,
              keymap = {
                  accept = "<C-l>",
              }
          },
          panel = { enabled = true },
      })

      require 'fidget'.setup()


      -- =======================================================================
      -- nvim-cmp
      -- =======================================================================

      local cmp = require("cmp")
      cmp.setup({
          view = {
              entries = { name = 'custom', selection_order = 'near_cursor' }
          },
          snippet = {
              expand = function(args)
                  require('luasnip').lsp_expand(args.body)
              end
          },
          window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
          },
          sources = cmp.config.sources({
              { name = "copilot", },
              { name = 'buffer' },
              { name = 'nvim_lsp' },
              { name = 'luasnip' },
              { name = 'treesitter' },
              { name = 'path' },
              { name = 'git' },
              { name = 'tmux' }
          }),
          mapping = cmp.mapping.preset.insert({
              ['<CR>'] = cmp.mapping.confirm(),
              ['<C-y>'] = cmp.mapping.complete(),
              -- ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-n>'] = cmp.config.next,
              ['<C-p>'] = cmp.config.prev,
          })
      })

      cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline {
              ['<C-n>'] = cmp.config.disable,
              ['<C-p>'] = cmp.config.disable,
          },
          sources = {
              { name = 'buffer' }
          }
      })
      cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline {
              ['<C-n>'] = cmp.config.disable,
              ['<C-p>'] = cmp.config.disable,
          },
          -- mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
              { name = 'path' }
          }, {
              { name = 'cmdline' }
          })
      })
      cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
              { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
          }, {
              { name = 'buffer' },
          })
      })
      require('crates').setup()
      require('outline').setup()
      require("noice").setup({
          lsp = {
              -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
              override = {
                  ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                  ["vim.lsp.util.stylize_markdown"] = true,
                  ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
              },
          },
          -- you can enable a preset for easier configuration
          presets = {
              bottom_search = true,         -- use a classic bottom cmdline for search
              command_palette = true,       -- position the cmdline and popupmenu together
              long_message_to_split = true, -- long messages will be sent to a split
              inc_rename = false,           -- enables an input dialog for inc-rename.nvim
              lsp_doc_border = true,        -- add a border to hover docs and signature help
          },
      })

      require 'FTerm'.setup({
          border     = 'double',
          dimensions = {
              height = 0.95,
              width = 0.95,
          },
          cmd        = "fish",
          blend      = 10,
      })
    '';
    # builtins.readFile ./extraConfig.lua;
    package = pkgs.neovim-nightly;
  };
}

