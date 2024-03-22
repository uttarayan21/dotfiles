{
  pkgs,
  config,
  inputs,
  device,
  ...
}: let
  mkMappings = mappings:
    []
    ++ (pkgs.lib.optionals (builtins.hasAttr "normal" mappings) (mkMode mappings.normal "n"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "terminal" mappings) (mkMode mappings.terminal "t"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "insert" mappings) (mkMode mappings.insert "i"));
  mkMode = mappings: mode:
    pkgs.lib.mapAttrsToList
    (key: value: {
      key = key;
      action = value;
      mode = mode;
      lua = true;
    })
    mappings;
in {
  imports = [inputs.nixvim.homeManagerModules.nixvim];
  programs.nixvim = {
    enable = true;
    extraPlugins = with pkgs.vimPlugins; [
      # neorg
      neorg
      neorg-telescope

      # Wut
      ChatGPT-nvim

      # UI and UX
      nvim-ufo
      vim-abolish
      telescope-nvim
      telescope-ui-select-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      telescope-dap-nvim
      octo-nvim
      neoscroll-nvim

      # Debuggging
      nvim-dap-rr

      # Treesitter stuff
      outline-nvim

      # lsp stuff
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-dap
      cmp_luasnip
      cmp-tmux
      cmp-treesitter
      cmp-git
      luasnip
      copilot-lua
      crates-nvim
      sqls-nvim

      # No more postman
      rest-nvim

      # UI
      nvim-web-devicons

      # Utils
      FTerm-nvim
      plenary-nvim
      nix-develop-nvim

      pkgs.tree-sitter-grammars.tree-sitter-just

      # Testing
      neotest
      # neotest-rust
    ];
    options = {
      shell = "sh";
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

    globals = {
      mapleader = " ";
    };
    plugins = {
      lsp = {
        enable = true;
        servers = {
          gopls.enable = true;
          nil_ls = {
            enable = true;
            settings = {
              formatting = {
                command = [
                  "${pkgs.alejandra}/bin/alejandra"
                  # "${pkgs.nixfmt}/bin/nixfmt"
                  # "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"
                ];
              };
            };
          };
          clangd.enable = true;
          lua-ls.enable = true;
          jsonls.enable = true;
          html.enable = true;
          pylyzer.enable = true;
          # rust-analyzer.enable = true;
        };
      };

      noice = {
        enable = true;
        notify.enabled = false;
      };
      fidget = {
        enable = true;
        notification.overrideVimNotify = true;
      };

      trouble.enable = true;
      rustaceanvim = {
        enable = true;
        server = {
          onAttach =
            /*
            lua
            */
            ''
              function(client, bufnr)
                  if client.server_capabilities.inlayHintProvider then
                      vim.lsp.inlay_hint.enable(bufnr, true)
                  end
              end
            '';
          settings =
            /*
            lua
            */
            ''
              function(project_root)
                local ra = require('rustaceanvim.config.server')
                  return ra.load_rust_analyzer_settings(project_root, {
                    settings_file_pattern = 'rust-analyzer.json'
                  })
              end
            '';
        };
        dap = {
          autoloadConfigurations = false;
        };
      };
      oil.enable = true;
      dap = {
        enable = true;
        extensions = {
          dap-ui.enable = true;
          dap-virtual-text.enable = true;
        };
      };
      todo-comments.enable = true;
      lualine.enable = true;
      commentary.enable = true;
      surround.enable = true;
      which-key.enable = true;
      # nvim-ufo = {
      #   enable = true;
      #   closeFoldKinds = null;
      #   providerSelector =
      #     /*
      #     lua
      #     */
      #     ''
      #       function(bufnr, filetype, buftype)
      #             return {'treesitter', 'indent'}
      #       end
      #     '';
      # };
      fugitive.enable = true;
      markdown-preview = {
        enable = true;
        settings.auto_start = true;
      };
      # rest.enable = true;
      treesitter-context = {
        maxLines = 3;
        mode = "topline";
        enable = true;
      };
      ts-context-commentstring.enable = true;

      treesitter = {
        enable = true;
        indent = true;
        folding = true;
        grammarPackages =
          pkgs.vimPlugins.nvim-treesitter.allGrammars
          ++ (with pkgs.tree-sitter-grammars; [
            tree-sitter-just
            tree-sitter-norg-meta
          ]);
      };
      telescope = {
        enable = true;
        extensions = {
          undo.enable = true;
          ui-select.enable = true;
          fzf-native.enable = true;
          file_browser.enable = true;
        };
      };

      mini = {
        enable = true;
        modules = {
          ai = {};
          starter = {};
          # pairs.enable = true;
          # cursorword.enable = true;
        };
      };
    };
    colorschemes = {
      catppuccin = {
        enable = true;
        flavour = "mocha";
      };
    };
    keymaps = mkMappings {
      normal = {
        "<leader>c" = "[[<cmd>ChatGPT<cr>]]";
        "<leader>o" = "[[<cmd>TroubleToggle<cr>]]";
        "<leader>ee" = "[[<cmd>Rest run<cr>]]";
        "<leader>el" = "[[<cmd>Rest run last<cr>]]";
        "vff" = "[[<cmd>vertical Gdiffsplit<cr>]]";
        "<leader>\"" = ''[["+]]'';
        "gh" = "[[<cmd>Octo actions<cr>]]";
        "<leader><leader>" = "'<c-^>'";
        "<leader>q" = "[[<cmd>bw<cr>]]";
        "<leader>n" = "[[<cmd>bnext<cr>]]";
        "<leader>p" = "[[<cmd>bprev<cr>]]";
        "<C-w>\"" = "[[<cmd>split<cr>]]";
        "<C-w>%" = "[[<cmd>vsplit<cr>]]";
        "<leader>dr" = "[[<cmd>RustLsp debuggables<cr>]]";
        "<C-l>" = "[[<cmd>Outline<cr>]]";

        "<leader>ff" = "require'telescope.builtin'.find_files";
        "<leader>fb" = "require'telescope'.extensions.file_browser.file_browser";
        "<leader>gg" = "require'telescope.builtin'.live_grep";
        "<leader>;" = "require'telescope.builtin'.buffers";
        "<C-k>" = "vim.lsp.buf.definition";
        "gi" = "require'telescope.builtin'.lsp_implementations";
        "<leader>a" = "vim.lsp.buf.code_action";
        "F" = "function() vim.lsp.buf.format({ async = true }) end";
        "<leader>bb" = "require'dap'.toggle_breakpoint";
        "<leader>du" = "require'dapui'.toggle";
        "<C-\\>" = "require('FTerm').toggle";
      };
      terminal = {
        "<C-\\>" = "require('FTerm').toggle";
      };
      insert = {
        "<C-\\>" = "require('FTerm').toggle";
      };
    };

    extraConfigLua = let
      codelldb =
        if device.isLinux
        then pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter
        else null;
      liblldb =
        if device.isLinux
        then "${codelldb}/lldb/lib/liblldb.so"
        # else if device.isMac then
        #   "${codelldb}/lldb/lib/liblldb.dylib"
        else null;
    in
      /*
      lua
      */
      ''
        require'neotest'.setup({
          adapters = {
              -- require('neotest-rust') {
              --     args = { "--no-capture" },
              -- }
              require('rustaceanvim.neotest'),
          }
        })

        do
            function setup()
                require('rest-nvim').setup()
            end
            success, output = pcall(setup)
            if not success then
                print("Failed to setup rest-nvim: " .. output)
            end
        end


        require('telescope').load_extension("dap")
        -- require('telescope').load_extension("rest")
        require('telescope').load_extension("neorg")

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

        -- require 'fidget'.setup()
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
                -- ['<C-n>'] = cmp.config.disable,
                -- ['<C-p>'] = cmp.config.disable,
            },
            sources = {
                { name = 'buffer' }
            }
        })
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline {
                -- ['<C-n>'] = cmp.config.disable,
                -- ['<C-p>'] = cmp.config.disable,
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
        -- require("noice").setup({
        --     lsp = {
        --         -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        --         override = {
        --             ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        --             ["vim.lsp.util.stylize_markdown"] = true,
        --             ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        --         },
        --     },
        --     -- you can enable a preset for easier configuration
        --     presets = {
        --         bottom_search = false,         -- use a classic bottom cmdline for search
        --         command_palette = true,       -- position the cmdline and popupmenu together
        --         long_message_to_split = true, -- long messages will be sent to a split
        --         inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        --         lsp_doc_border = true,        -- add a border to hover docs and signature help
        --     },
        -- })

        require 'FTerm'.setup({
            border     = 'double',
            dimensions = {
                height = 0.95,
                width = 0.95,
            },
            cmd        = "fish",
            blend      = 10,
        })

        require('neorg').setup({
            load = {
                ["core.defaults"] = {},
                ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
                ["core.concealer"] = {
                    config = { icon_preset = "diamond" }
                },
                ["core.keybinds"] = {
                   -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
                   config = {
                     default_keybinds = true,
                     neorg_leader = "<leader>n",
                   },
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            default = "~/Nextcloud/Notes",
                            Work = "~/Nextcloud/Work",
                        }
                    }
                }
            }
        })
        vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
          pattern = {"*.norg"},
          command = "set conceallevel=3"
        })

        require('chatgpt').setup({
            api_key_cmd = "rbw get platform.openai.com",
        })

        require"octo".setup({
          use_local_fs = false,
          enable_builtin = false,
          default_remote = {"upstream", "origin"};
        })

        local rr_dap = require('nvim-dap-rr')
        rr_dap.setup({
            mappings = {
                continue = "<F7>"
            },
        })

        local dap = require'dap';
        dap.configurations.rust = { rr_dap.get_rust_config() }
        dap.configurations.cpp = { rr_dap.get_config() }

        require('neoscroll').setup()
        do
            function setup()
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                capabilities.textDocument.foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true
                }
                local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
                for _, ls in ipairs(language_servers) do
                    require('lspconfig')[ls].setup({
                        capabilities = capabilities
                        -- you can add other fields for setting up lsp server in this table
                    })
                end
            end
            success, output = pcall(setup)
            if not success then
                print("Failed to setup lspconfig folds: " .. output)
            end
        end
        require('ufo').setup()
      '';
    package = pkgs.neovim-nightly;
  };
}
