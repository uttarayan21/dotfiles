{
  pkgs,
  stablePkgs,
  ...
}: let
  mkMappings = mappings:
    []
    ++ (pkgs.lib.optionals (builtins.hasAttr "normal" mappings) (mkMode mappings.normal "n"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "terminal" mappings) (mkMode mappings.terminal "t"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "insert" mappings) (mkMode mappings.insert "i"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "visual" mappings) (mkMode mappings.visual "v"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "global" mappings) (mkMode mappings.global ""));
  mkMode = mappings: mode:
    pkgs.lib.mapAttrsToList (key: value: {
      key = key;
      action = rawLua value;
      mode = mode;
    })
    mappings;
  border = [
    "╭"
    "─"
    "╮"
    "│"
    "╯"
    "─"
    "╰"
    "│"
  ];
  rawLua = lua: {
    "__raw" = ''
      ${lua}
    '';
  };
in {
  opts = {
    completeopt = "menu,menuone,popup,noselect";
    expandtab = true;
    foldenable = true;
    foldlevel = 99;
    foldlevelstart = 99;
    hidden = true;
    number = true;
    relativenumber = true;
    shell = "sh";
    shiftwidth = 4;
    signcolumn = "yes";
    smartcase = true;
    softtabstop = 4;
    tabstop = 4;
    termguicolors = true;
    undofile = true;
    viewoptions = "cursor,folds";
    wrap = true;
  };
  globals = {
    mapleader = " ";
    localleader = " ";
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
      "<leader>o" = "[[<cmd>Trouble diagnostics<cr>]]";
      "<leader>p" = "[[<cmd>bprev<cr>]]";
      "<leader>q" = "[[<cmd>bw<cr>]]";
      "<leader>mm" = "[[<cmd>Neorg<cr>]]";
      "vff" = "[[<cmd>vertical Gdiffsplit<cr>]]";

      "<leader>rr" = "vim.lsp.buf.rename";
      "<C-k>" = "vim.lsp.buf.definition";
      "<C-\\>" = "require('FTerm').toggle";
      # "F" = "function() vim.lsp.buf.format({ async = true }) end";
      "F" = "require('conform').format";
      "gi" = "require'telescope.builtin'.lsp_references";
      "<leader>a" = "vim.lsp.buf.code_action";
      "<leader>bb" = "require'dap'.toggle_breakpoint";
      "<leader>du" = "require'dapui'.toggle";
      "<leader>fb" = "require'telescope'.extensions.file_browser.file_browser";
      "<leader>fg" = "require'yazi'.yazi";
      "<leader>ff" = "require'telescope.builtin'.find_files";
      "<leader>gg" = "require'telescope.builtin'.live_grep";
      "<leader>;" = "require'telescope.builtin'.buffers";
      "zR" = "require'ufo'.openAllFolds";
      "zM" = "require'ufo'.closeAllFolds";

      # Emulate tmux bindings with prefix <C-q> and tabs
      "<C-q><C-q>" = "[[g<Tab>]]";
      "<C-q>c" = "[[<cmd>tabnew<cr>]]";
      "<C-q>x" = "[[<cmd>tabclose<cr>]]";
      "<C-q>n" = "[[<cmd>tabnext<cr>]]";
      "<C-q>p" = "[[<cmd>tabprevious<cr>]]";
      "<c-.>" = "require('sidekick.cli').toggle";
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
      event = [
        "BufEnter"
        "BufWinEnter"
      ];
      pattern = "*.norg";
      command = "set conceallevel=3";
    }
    {
      event = [
        "BufEnter"
        "BufWinEnter"
      ];
      pattern = "*.pest";
      command = "setlocal commentstring=//%s";
    }
    # {
    #   event = ["BufEnter" "BufWinEnter"];
    #   pattern = "*.sql";
    #   command = "nnoremap <buffer> F :Sqlfmt<cr>";
    # }
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
    {
      event = ["FileType"];
      pattern = "json";
      callback =
        rawLua
        /*
        lua
        */
        ''
          function(ev)
              vim.bo[ev.buf].formatprg = "${pkgs.jq}/bin/jq"
          end
        '';
    }
  ];

  plugins = {
    fugitive.enable = true;
    gitsigns.enable = true;
    neogit.enable = true;
    web-devicons.enable = true;
    vim-surround.enable = true;
    todo-comments.enable = true;
    trouble.enable = true;
    ts-context-commentstring.enable = true;
    which-key.enable = true;

    sidekick = {
      enable = true;
      settings = {
        nes = {
          enabled = false;
        };
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save =
          # lua
          ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end
              return { timeout_ms = 500, lsp_format = "fallback" }
            end
          '';
        formatters_by_ft = {
          json = ["jq"];
          d2 = ["d2"];
          sql = ["sleek"];
          toml = ["taplo"];
          nix = ["alejandra"];
        };
      };
    };
    copilot-lua = {
      enable = true;
      settings = {
        panel = {
          enabled = false;
        };
        suggestion = {
          enabled = true;
          auto_trigger = true;
          keymap = {
            accept = "<C-l>";
          };
        };
      };
    };

    yazi = {
      enable = true;
      settings = {
        open_for_directories = true;
        keymaps = {
          show_help = "<f1>";
          open_file_in_vertical_split = "<c-v>";
          open_file_in_horizontal_split = "<c-x>";
          open_file_in_tab = "<c-t>";
          grep_in_directory = "<c-s>";
          replace_in_directory = "<c-g>";
          cycle_open_buffers = "<tab>";
          copy_relative_path_to_selected_files = "<c-y>";
          send_to_quickfix_list = "<c-q>";
          change_working_directory = "<c-c>";
        };
      };
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
      # package = stablePkgs.vimPlugins.lualine-nvim;
    };

    neotest = {
      enable = true;
      settings = {
        adapters = [
          ''require('rustaceanvim.neotest')''
        ];
      };
    };
    neorg = {
      enable = true;
      settings.load = {
        "core.defaults" = {
          __empty = null;
        };
        "core.completion" = {
          config = {
            engine = "nvim-cmp";
            name = "[Norg]";
          };
        };
        "core.concealer" = {
          config = {
            icon_preset = "diamond";
          };
        };
        "core.keybinds" = {
          config = {
            default_keybinds = true;
            neorg_leader = "<C-m>";
          };
        };
        "core.integrations.treesitter" = {
          config.install_parsers = false;
          config.configure_parsers = false;
        };

        # "core.integrations.image" = {
        #   config.tmux_show_only_in_active_window = true;
        # };

        "core.dirman" = {
          config = {
            default_workspace = "Notes";
            workspaces = {
              Notes = "~/Nextcloud/Notes";
              Work = "~/Nextcloud/Work";
            };
          };
        };
      };
    };

    rest = {
      enable = true;
      enableTelescope = true;
      settings.response.hooks.format = true;
    };

    comment = {
      enable = true;
      settings.pre_hook =
        # lua
        ''
          require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
        '';
    };

    molten = {
      enable = true;
      settings.image_provider = "image.nvim";
    };

    # markdown-preview = {
    #   enable = true;
    #   package = pkgs.vimUtils.buildVimPlugin {
    #     pname = "markdown-preview.nvim";
    #     version = "0.0.10-unstable-2026-1-4";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "iamcco";
    #       repo = "markdown-preview.nvim";
    #       rev = "a923f5fc5ba36a3b17e289dc35dc17f66d0548ee";
    #       hash = "sha256-TBXdG/Ih5DusAYZJyn37zVqHcMD85VkjrCoLyTo/KBg=";
    #     };
    #     patches = [../patches/markdown-preview.patch];
    #   };
    # };

    noice = {
      enable = true;
      settings = {
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
    };

    treesitter = {
      enable = true;
      settings = {
        indent.enable = true;
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = true;
        };
      };
      folding.enable = true;
      grammarPackages =
        (with pkgs.tree-sitter-grammars; [
          tree-sitter-norg
          tree-sitter-norg-meta
          tree-sitter-just
          tree-sitter-nu
          tree-sitter-pest
          tree-sitter-slint
        ])
        ++ pkgs.vimPlugins.nvim-treesitter.allGrammars;
      nixGrammars = true;
    };

    telescope = {
      enable = true;
      settings = {
        defaults = {
          layout_strategy = "horizontal";
          layout_config = {
            # preview_height = 0.8;
            vertical = {
              size = {
                width = "99%";
                height = "99%";
              };
            };
          };
        };
      };
      extensions = {
        undo.enable = true;
        ui-select.enable = true;
        fzf-native = {
          enable = true;
          settings = {
            fuzzy = true;
            override_generic_sorter = true;
            override_file_sorter = true;
          };
        };
        file-browser.enable = true;
      };
    };

    fidget = {
      enable = true;
      settings.notification.override_vim_notify = true;
    };

    dap.enable = true;
    dap-ui.enable = true;
    dap-virtual-text.enable = true;

    nvim-ufo = {
      enable = true;
      settings = {
        close_fold_kinds = null;
        provider_selector =
          # lua
          ''
            function(bufnr, filetype, buftype)
                  return {'treesitter', 'indent'}
            end
          '';
      };
    };
    rustaceanvim = {
      enable = true;
      settings = {
        server = {
          on_attach =
            rawLua
            # lua
            ''
              function(client, bufnr)
                  vim.keymap.set(
                    "n",
                    "<leader>a",
                    function()
                      vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
                      -- or vim.lsp.buf.codeAction() if you don't want grouping.
                    end,
                    { silent = true, buffer = bufnr }
                  )
                  vim.keymap.set(
                    "n",
                    "K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
                    function()
                      vim.cmd.RustLsp({'hover', 'actions'})
                    end,
                    { silent = true, buffer = bufnr }
                  )
              end
            '';
          default_settings = {
            rust-analyzer = {
              inlayHints = {
                genericParameterHints = {
                  lifetime.enable = true;
                };
                # implicitDrops.enable = true;
              };
              files = {
                excludeDirs = [
                  ".cargo/"
                  ".direnv/"
                  ".git/"
                  ".vcpkg/"
                  "node_modules/"
                  "target/"
                ];
              };
              diagnostics = {
                enable = true;
                styleLints.enable = true;
              };

              checkOnSave = true;
              check = {
                command = "check";
                features = "all";
              };
            };
          };
        };
        dap = let
          vscode-lldb = pkgs.vscode-extensions.vadimcn.vscode-lldb;
          liblldb =
            if pkgs.stdenv.isLinux
            then "${vscode-lldb.lldb}/lib/liblldb.so"
            else if pkgs.stdenv.isDarwin
            then "${vscode-lldb.lldb}/lib/liblldb.dylib"
            else null;
          codelldb = "${vscode-lldb.adapter}/bin/codelldb";
        in {
          autoload_configurations = false;
          adapter =
            /*
            lua
            */
            ''
              require('rustaceanvim.config').get_codelldb_adapter("${codelldb}", "${liblldb}")
            '';
        };
        tools = {
          float_win_config = {
            border = "rounded";
          };
          enable_clippy = false;
        };
      };
    };

    lsp = {
      enable = true;
      servers = {
        taplo.enable = true;
        gopls.enable = true;
        nil_ls = {
          enable = true;
          settings = {
            formatting.command = [
              "${pkgs.alejandra}/bin/alejandra"
            ];
            nix.flake.autoArchive = true;
          };
        };
        # marksman.enable = true;
        neocmake.enable = true;
        nushell.enable = true;
        clangd.enable = true;
        lua_ls.enable = true;
        jsonls.enable = true;
        html.enable = true;
        htmx.enable = true;
        elixirls.enable = true;
        ast_grep.enable = true;
        sqls.enable = true;
        pyright.enable = true;
        slint_lsp.enable = true;
        wgsl_analyzer.enable = true;
        # sourcekit.enable = true;
        openscad_lsp.enable = true;
        tinymist.enable = true;
        rust_analyzer = {
          enable = false;
          installCargo = false;
          installRustc = false;
          settings = {
            inlayHints = {
              typeHints.enable = false;
            };
            check = {
              features = ["default"];
            };
            files.exclude = [
              ".cargo/"
              ".direnv/"
              ".git/"
              ".vcpkg/"
              "node_modules/"
              "target/"
              "vendor/"
            ];
          };
        };
      };
      # onAttach =
      #   /*
      #   lua
      #   */
      #   ''
      #     if client.server_capabilities.inlayHintProvider then
      #         vim.lsp.inlay_hint.enable(true)
      #     end
      #   '';
    };
    blink-cmp = {
      enable = true;
      settings = {
        completion = {
          documentation.window.border = "rounded";
          menu.border = "rounded";
        };
        signature = {
          window.border = "rounded";
        };
        keymap = {
          "<CR>" = ["select_and_accept" "fallback"];
          "<C-n>" = [
            "select_next"
            "fallback"
          ];
          "<C-p>" = [
            "select_prev"
            "fallback"
          ];
          "<C-u>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-d>" = [
            "scroll_documentation_down"
            "fallback"
          ];
        };
        sources = {
          cmdline = [];
          default = [
            "git"
            "lsp"
            "dictionary"
            "snippets"
            "path"
            "buffer"
            "ripgrep"
          ];
          providers = {
            buffer = {
              score_offset = -7;
            };
            lsp = {
              fallbacks = [];
            };
            path = {};
            dictionary = {
              module = "blink-cmp-dictionary";
              name = "Dict";
              min_keyword_length = 3;
              opts = {
              };
            };
            git = {
              module = "blink-cmp-git";
              name = "Git";
              opts = {
                # -- options for the blink-cmp-git
              };
            };
            ripgrep = {
              module = "blink-ripgrep";
              name = "Ripgrep";
              opts = {};
            };
          };
        };
      };
    };
    blink-ripgrep.enable = true;
    blink-cmp-git.enable = true;
    blink-cmp-dictionary.enable = true;
    blink-cmp-copilot.enable = true;
    blink-cmp-spell.enable = true;
    blink-compat = {
      enable = true;
      settings.impersonate_nvim_cmp = true;
    };
  };
  extraConfigLua =
    # lua
    ''
       function catcher(callback)
           do
               success, output = pcall(callback)
               if not success then
                   print("Failed to setup: " .. output)
               end
           end
       end

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

       require('octo').setup({
         use_local_fs = false,
         enable_builtin = false,
         default_remote = {"upstream", "origin"};
         default_merge_method = "squash";
       })

       if not vim.g.neovide then
           require('neoscroll').setup()
           require('image').setup({["backend"] = "kitty",["tmux_show_only_in_active_window"] = true})
       else
           vim.o.guifont = "Hasklug Nerd Font Mono:h13"
           vim.g.neovide_cursor_vfx_mode = "railgun"
       end

       require('lspconfig.ui.windows').default_options.border = 'single'

       catcher(require('nvim_context_vt').setup)

       vim.api.nvim_create_user_command('Reso',
           function()
               pcall(vim.cmd'source ~/.config/nvim/init.lua')
           end,
       {})

       vim.api.nvim_create_user_command("FormatDisable", function(args)
         if args.bang then
           -- FormatDisable! will disable formatting just for this buffer
           vim.b.disable_autoformat = true
         else
           vim.g.disable_autoformat = true
         end
       end, {
         desc = "Disable autoformat-on-save",
         bang = true,
       })
       vim.api.nvim_create_user_command("FormatEnable", function()
         vim.b.disable_autoformat = false
         vim.g.disable_autoformat = false
       end, {
         desc = "Re-enable autoformat-on-save",
       })

       vim.api.nvim_create_user_command('Sqlfmt',
           function()
               pcall(vim.cmd'%!${pkgs.sleek}/bin/sleek')
           end,
       {})

       vim.api.nvim_create_user_command('DapUiToggle',
          function()
            require('dapui').toggle()
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
             slint = "slint",
          },
       })

       vim.filetype.add({
          extension = {
             pest = "pest",
          },
       })

       vim.filetype.add({
           filename = {
               ['nurfile'] = "nu",
           },
       })

       vim.bo.formatexpr = "v:lua.require'conform'.formatexpr()"

    '';
  extraPlugins = with pkgs.vimPlugins; [
    FTerm-nvim
    crates-nvim
    image-nvim
    iron-nvim
    luasnip
    neoscroll-nvim
    nvim-web-devicons
    nvim_context_vt
    octo-nvim
    outline-nvim
    plenary-nvim
    vim-abolish
    vim-speeddating
    webapi-vim

    pkgs.tree-sitter-grammars.tree-sitter-just
    pkgs.tree-sitter-grammars.tree-sitter-norg
    pkgs.tree-sitter-grammars.tree-sitter-norg-meta
    pkgs.tree-sitter-grammars.tree-sitter-nu
  ];
  extraLuaPackages = luaPkgs:
    with luaPkgs; [
      lua-utils-nvim
      nvim-nio
      pathlib-nvim
    ];
  extraPackages = [
    pkgs.lldb
    pkgs.taplo
    pkgs.d2
    pkgs.sleek
    pkgs.graphqurl
    pkgs.sqls
    pkgs.lua
    pkgs.ripgrep
    pkgs.nodejs-slim
  ];
}
