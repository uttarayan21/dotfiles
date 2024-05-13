{pkgs, ...}: let
  mkMappings = mappings:
    []
    ++ (pkgs.lib.optionals (builtins.hasAttr "normal" mappings) (mkMode mappings.normal "n"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "terminal" mappings) (mkMode mappings.terminal "t"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "insert" mappings) (mkMode mappings.insert "i"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "visual" mappings) (mkMode mappings.visual "v"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "global" mappings) (mkMode mappings.global ""));
  mkMode = mappings: mode:
    pkgs.lib.mapAttrsToList
    (key: value: {
      key = key;
      action = value;
      mode = mode;
      lua = true;
    })
    mappings;
  border = ["╭" "─" "╮" "│" "╯" "─" "╰" "│"];
  rawLua = lua: {
    "__raw" = ''
      ${lua}
    '';
  };
in rec {
  neovim = (pkgs.nixvim.makeNixvim config) // {config = config;};
  config = {
    plugins = {
      fugitive.enable = true;
      gitsigns.enable = true;
      neogit.enable = true;
      surround.enable = true;
      todo-comments.enable = true;
      trouble.enable = true;
      ts-context-commentstring.enable = true;
      which-key.enable = true;

      oil = {
        enable = true;
        settings.skip_confirm_for_simple_edits = true;
      };

      navic = {
        enable = true;
        lsp.autoAttach = true;
      };

      mini = {
        enable = true;
        modules = {
          ai = {};
          starter = {};
        };
      };

      lualine = {
        enable = true;
        sections = {
          lualine_c = [
            {
              name =
                rawLua
                /*
                lua
                */
                ''
                  function(bufnr)
                      local opts = { highlight = true }
                      return require'nvim-navic'.get_location(opts)
                  end,
                  cond = function()
                      return require'nvim-navic'.is_available()
                  end
                '';
            }
          ];
        };
      };

      comment = {
        enable = true;
        settings.pre_hook =
          /*
          lua
          */
          ''
            require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
          '';
      };

      markdown-preview = {
        enable = true;
        settings.auto_start = false;
      };

      noice = {
        enable = true;
        notify.enabled = false;
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        presets = {
          bottom_search = false;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = false;
          lsp_doc_border = true;
        };
      };

      treesitter = {
        enable = true;
        indent = true;
        folding = true;
        grammarPackages =
          pkgs.vimPlugins.nvim-treesitter.allGrammars
          ++ (with pkgs.tree-sitter-grammars; [
            tree-sitter-just
            tree-sitter-nu
            tree-sitter-d2
            tree-sitter-norg-meta
          ]);
      };

      telescope = {
        enable = true;
        # settings = {
        #   defaults = {
        #     layout_strategy = "vertical";
        #     layout_config = {
        #       preview_height = 0.8;
        #       vertical = {
        #         size = {
        #           width = "99%";
        #           height = "99%";
        #         };
        #       };
        #     };
        #   };
        # };
        extensions = {
          undo.enable = true;
          ui-select.enable = true;
          fzf-native.enable = true;
          file-browser.enable = true;
        };
      };

      fidget = {
        enable = true;
        notification.overrideVimNotify = true;
      };

      dap = {
        enable = true;
        extensions = {
          dap-ui.enable = true;
          dap-virtual-text.enable = true;
        };
      };

      nvim-ufo = {
        enable = true;
        closeFoldKinds = null;
        providerSelector =
          /*
          lua
          */
          ''
            function(bufnr, filetype, buftype)
                  return {'treesitter', 'indent'}
            end
          '';
      };
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
                      vim.lsp.inlay_hint.enable(true)
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
          cmd =
            /*
            lua
            */
            ''
              function()
                return { '${pkgs.ra-multiplex}/bin/ra-multiplex', 'client' }
              end
            '';
        };
        dap = {
          autoloadConfigurations = false;
        };
      };

      lsp = {
        enable = true;
        servers = {
          gopls.enable = true;
          nil_ls = {
            enable = true;
            settings.formatting.command = [
              "${pkgs.alejandra}/bin/alejandra"
            ];
            # nix.flake.autoArchive = true;
          };
          marksman.enable = true;
          nushell.enable = true;
          clangd.enable = true;
          lua-ls.enable = true;
          jsonls.enable = true;
          html.enable = true;
          ast-grep.enable = true;
          # pylyzer.enable = true;
          # rust-analyzer.enable = true;
        };
        onAttach =
          /*
          lua
          */
          ''
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(bufnr, true)
            end
          '';
      };
      cmp = {
        enable = true;
        settings = {
          autoEnableSources = true;
          sources = [
            {name = "buffer";}
            {name = "buffer";}
            {name = "cmdline";}
            {name = "cmp-clippy";}
            {name = "cmp-cmdline-history";}
            {name = "crates";}
            {name = "dap";}
            {name = "dictionary";}
            {name = "fish";}
            {name = "git";}
            {name = "luasnip";}
            {name = "nvim_lsp";}
            {name = "nvim_lua";}
            {name = "nvim_lsp_signature_help";}
            {name = "nvim_lsp_document_symbol";}
            {name = "path";}
            {name = "rg";}
            {name = "spell";}
            {name = "tmux";}
            {name = "treesitter";}
          ];
          view = {
            entries = {
              name = "custom";
              selection_order = "near_cursor";
            };
          };
          window = {
            completion = {
              inherit border;
            };
            documentation = {
              inherit border;
            };
          };
          mapping = {
            # "<CR>" = "cmp.mapping.confirm({select = true})";
            "<CR>" = "cmp.mapping.confirm()";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
          snippet.expand =
            /*
            lua
            */
            ''
              function(args)
                  require('luasnip').lsp_expand(args.body)
              end
            '';
        };
      };
    };
    globals = {
      mapleader = " ";
    };
    colorschemes = {
      catppuccin = {
        enable = true;
        settings.flavour = "mocha";
      };
    };
    keymaps = mkMappings {
      normal = {
        "<C-l>" = "[[<cmd>Outline<cr>]]";
        "<C-w>\"" = "[[<cmd>split<cr>]]";
        "<C-w>%" = "[[<cmd>vsplit<cr>]]";
        "gh" = "[[<cmd>Octo actions<cr>]]";
        "<leader>\"" = ''[["+]]'';
        "<C-c>" = "[[<cmd>ChatGPT<cr>]]";
        "<leader>dr" = "[[<cmd>RustLsp debuggables<cr>]]";
        "<leader>ee" = "[[<cmd>Rest run<cr>]]";
        "<leader>el" = "[[<cmd>Rest run last<cr>]]";
        "<leader>hh" = "[[<cmd>DevdocsOpen<cr>]]";
        "<leader>hl" = "[[<cmd>DevdocsToggle<cr>]]";
        "<leader><leader>" = "'<c-^>'";
        "<leader>n" = "[[<cmd>bnext<cr>]]";
        "<leader>o" = "[[<cmd>TroubleToggle<cr>]]";
        "<leader>p" = "[[<cmd>bprev<cr>]]";
        "<leader>q" = "[[<cmd>bw<cr>]]";
        "<leader>mm" = "[[<cmd>Neorg<cr>]]";
        "vff" = "[[<cmd>vertical Gdiffsplit<cr>]]";

        "<leader>rr" = "vim.lsp.buf.rename";
        "<C-k>" = "vim.lsp.buf.definition";
        "<C-\\>" = "require('FTerm').toggle";
        "F" = "function() vim.lsp.buf.format({ async = true }) end";
        "gi" = "require'telescope.builtin'.lsp_references";
        "<leader>a" = "vim.lsp.buf.code_action";
        "<leader>bb" = "require'dap'.toggle_breakpoint";
        "<leader>du" = "require'dapui'.toggle";
        "<leader>fb" = "require'telescope'.extensions.file_browser.file_browser";
        "<leader>ff" = "require'telescope.builtin'.find_files";
        "<leader>gg" = "require'telescope.builtin'.live_grep";
        "<leader>;" = "require'telescope.builtin'.buffers";

        # Emulate tmux bindings with prefix <C-q> and tabs
        "<C-q><C-q>" = "[[g<Tab>]]";
        "<C-q>c" = "[[<cmd>tabnew<cr>]]";
        "<C-q>x" = "[[<cmd>tabclose<cr>]]";
        "<C-q>n" = "[[<cmd>tabnext<cr>]]";
        "<C-q>p" = "[[<cmd>tabprevious<cr>]]";
      };
      terminal = {
        "<C-\\>" = "require('FTerm').toggle";
      };
      insert = {
        "<C-\\>" = "require('FTerm').toggle";
      };
      visual = {
        "L" = "[[:'<,'>!sort -u<cr>]]";
      };
    };

    autoCmd = [
      {
        event = ["BufEnter" "BufWinEnter"];
        pattern = "*.norg";
        command = "set conceallevel=3";
      }
      {
        event = ["BufWinLeave"];
        pattern = "?*";
        command = "mkview!";
      }
      {
        event = ["BufWinEnter"];
        pattern = "?*";
        command = "silent! loadview!";
      }
    ];

    extraConfigLua = let
      codelldb =
        if pkgs.stdenv.isLinux
        then pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter
        else null;
      liblldb =
        if pkgs.stdenv.isLinux
        then "${codelldb}/lldb/lib/liblldb.so"
        # else if device.isMac then
        #   "${codelldb}/lldb/lib/liblldb.dylib"
        else null;
    in
      /*
      lua
      */
      ''
        function catcher(callback)
            do
                success, output = pcall(callback)
                if not success then
                    print("Failed to setup: " .. output)
                end
            end
        end

        do
            function setup()
                require'neotest'.setup({
                  adapters = {
                      require('rustaceanvim.neotest'),
                  }
                })
            end
            success, output = pcall(setup)
            if not success then
                print("Failed to setup neotest: " .. output)
            end
        end

        catcher(require('rest-nvim').setup)

        catcher(require('lspconfig').ast_grep.setup)

        -- require('telescope').load_extension("dap")
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

        catcher(require('crates').setup)
        catcher(require('outline').setup)

        require('FTerm').setup({
            border     = 'single',
            dimensions = {
                height = 0.99,
                width = 0.95,
            },
            cmd        = "sh -c 'tmux new -As scratch'",
            blend      = 10,
        })

        local load = {
            ["core.defaults"] = {},
            ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
            ["core.concealer"] = {
                config = { icon_preset = "diamond" }
            },
            ["core.export"] = {},
            ["core.keybinds"] = {
               -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
               config = {
                 default_keybinds = true,
                 neorg_leader = "<C-m>",
               },
            },
            ["core.dirman"] = {
                config = {
                    default_workspace = "Notes",
                    workspaces = {
                        Notes = "~/Nextcloud/Notes",
                        Work = "~/Nextcloud/Work",
                    }
                }
            }
        }

        require('neorg').setup({
            load = load,
        })

        require('chatgpt').setup({
            api_key_cmd = "${pkgs.rbw}/bin/rbw get platform.openai.com",
        })
        -- require("gp").setup({
        --     openai_api_key = { "${pkgs.rbw}/bin/rbw", "get", "platform.openai.com" },
        -- })

        require('octo').setup({
          use_local_fs = false,
          enable_builtin = false,
          default_remote = {"upstream", "origin"};
          default_merge_method = "squash";
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

        if not vim.g.neovide then
            require('neoscroll').setup()
            require('image').setup({["backend"] = "kitty",["tmux_show_only_in_active_window"] = true})
            load["core.integrations.image"] = {
                config = {
                    tmux_show_only_in_active_window = true,
                }
            }
            -- require("pets").setup({
            -- })
        else
            vim.o.guifont = "Hasklug Nerd Font Mono:h13"
            vim.g.neovide_cursor_vfx_mode = "railgun"
        end


        -- do
        --     function setup()
        --         local capabilities = vim.lsp.protocol.make_client_capabilities()
        --         capabilities.textDocument.foldingRange = {
        --             dynamicRegistration = false,
        --             lineFoldingOnly = true
        --         }
        --         -- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
        --         local language_servers = {"nil_ls"};
        --         for _, ls in ipairs(language_servers) do
        --             require('lspconfig')[ls].setup({
        --                 capabilities = capabilities
        --                 -- you can add other fields for setting up lsp server in this table
        --             })
        --         end
        --     end
        --     success, output = pcall(setup)
        --     if not success then
        --         print("Failed to setup lspconfig folds: " .. output)
        --     end
        -- end
        require('lspconfig.ui.windows').default_options.border = 'single'

        catcher(require('nvim_context_vt').setup)
        catcher(function()
            require('nvim-devdocs').setup({
                ensure_installed = {"nix", "rust"},
                float_win = {
                    relative = "editor",
                    height = 80,
                    width = 100,
                    border = "rounded",
                },
                after_open = function()
                    vim.o.conceallevel = 3
                end,
            })
        end)
        vim.g.rustaceanvim["tools"] = { enable_clippy = false };

        vim.api.nvim_create_user_command('Reso',
        function()
            pcall(vim.cmd'source ~/.config/nvim/init.lua')
        end,
        {})

        vim.api.nvim_create_user_command('Sqlfmt',
        function()
            pcall(vim.cmd'%!${pkgs.sleek}/bin/sleek')
        end,
        {})

        local iron = require("iron.core")
        iron.setup({
          config = {
            -- Whether a repl should be discarded or not
            scratch_repl = true,
            -- Your repl definitions come here
            repl_definition = {
              sh = {
                -- Can be a table or a function that
                -- returns a table (see below)
                command = {"${pkgs.zsh}/bin/zsh"}
              },
              sql = {
                command = function(meta)
                    local db = os.getenv("DATABASE_PATH")
                    if db == nil then
                        return { '${pkgs.sqlite}/bin/sqlite3', ':memory:' }
                    else
                        return { '${pkgs.sqlite}/bin/sqlite3', db }
                    end

                end
              },
              rust = {
                command = {"${pkgs.evcxr}/bin/evcxr"}
              },
            },
            -- How the repl window will be displayed
            -- See below for more information
            repl_open_cmd = require('iron.view').right(60),
          },
          -- Iron doesn't set keymaps by default anymore.
          -- You can set them here or manually add keymaps to the functions in iron.core
          keymaps = {
            send_motion = "<space>sc",
            visual_send = "<space>sc",
            send_file = "<space>sf",
            send_line = "<space>sl",
            send_until_cursor = "<space>su",
            send_mark = "<space>sm",
            mark_motion = "<space>mc",
            mark_visual = "<space>mc",
            remove_mark = "<space>md",
            cr = "<space>s<cr>",
            interrupt = "<space>s<space>",
            exit = "<space>sq",
            clear = "<space>cl",
          },
          -- If the highlight is on, you can change how it looks
          -- For the available options, check nvim_set_hl
          highlight = {
            italic = true
          },
          ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
        })

        vim.filetype.add({
          extension = {
            http = "http",
          },
        })

        vim.filetype.add({
            filename = {
                ['nurfile'] = "nu",
            },
        })

      '';
    package = pkgs.neovim-nightly;
    opts = {
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
      # undodir = "${config.xdg.cacheHome}/undodir";
      undofile = true;
      viewoptions = "cursor,folds";
      # concealcursor = "n";
      foldlevelstart = 99;
    };
    extraPlugins = with pkgs.vimPlugins; [
      # neorg
      neorg
      neorg-telescope

      # Wut
      image-nvim
      ChatGPT-nvim
      # gp-nvim
      # pets-nvim

      # UI and UX
      vim-abolish
      octo-nvim
      neoscroll-nvim

      # Debuggging
      nvim-dap-rr

      # Treesitter stuff
      outline-nvim

      # lsp stuff
      copilot-lua
      crates-nvim
      luasnip

      # No more postman
      rest-nvim

      # UI
      nvim-web-devicons

      # Utils
      FTerm-nvim
      plenary-nvim
      vim-speeddating

      # Testing
      neotest

      # Helper libs
      webapi-vim

      # Treesitter
      nvim_context_vt
      nvim-devdocs

      iron-nvim
      d2

      pkgs.tree-sitter-grammars.tree-sitter-just
      pkgs.tree-sitter-grammars.tree-sitter-nu
    ];
  };
}
