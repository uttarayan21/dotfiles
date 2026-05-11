{
  pkgs,
  lib,
  ...
}: {
  programs.nvf.settings.vim = {
    extraPlugins = {
      FTerm-nvim = {
        package = pkgs.vimPlugins.FTerm-nvim;
        setup = ''
          require('FTerm').setup({
            border     = 'single',
            dimensions = {
              height = 0.99,
              width = 0.95,
            },
            cmd        = "sh -c 'tmux new -As scratch'",
            blend      = 10,
          })
        '';
      };

      iron-nvim = {
        package = pkgs.vimPlugins.iron-nvim;
        setup = ''
          local iron = require("iron.core")
          iron.setup({
            config = {
              scratch_repl = true,
              repl_definition = {
                sh = { command = {"${pkgs.zsh}/bin/zsh"} },
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
              repl_open_cmd = require('iron.view').right(60),
            },
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
            highlight = { italic = true },
            ignore_blank_lines = true,
          })
        '';
      };

      octo-nvim = {
        package = pkgs.vimPlugins.octo-nvim;
        setup = ''
          require('octo').setup({
            use_local_fs = false,
            enable_builtin = false,
            default_remote = {"upstream", "origin"},
            default_merge_method = "squash",
          })
        '';
      };

      webapi-vim.package = pkgs.vimPlugins.webapi-vim;
      plenary-nvim.package = pkgs.vimPlugins.plenary-nvim;

      image-nvim = {
        package = pkgs.vimPlugins.image-nvim;
        setup = ''
          if not vim.g.neovide then
            require('image').setup({
              ["backend"] = "kitty",
              ["tmux_show_only_in_active_window"] = true,
            })
          end
        '';
      };

      neoscroll-nvim = {
        package = pkgs.vimPlugins.neoscroll-nvim;
        setup = ''
          if not vim.g.neovide then
            require('neoscroll').setup()
          end
        '';
      };

      outline-nvim = {
        package = pkgs.vimPlugins.outline-nvim;
        setup = ''
          local ok, mod = pcall(require, 'outline')
          if ok then mod.setup() end
        '';
      };

      nvim_context_vt = {
        package = pkgs.vimPlugins.nvim_context_vt;
        setup = ''
          local ok, mod = pcall(require, 'nvim_context_vt')
          if ok then mod.setup() end
        '';
      };

      vim-abolish.package = pkgs.vimPlugins.vim-abolish;
      vim-speeddating.package = pkgs.vimPlugins.vim-speeddating;

      opencode-nvim = {
        package = pkgs.vimPlugins.opencode-nvim;
        setup = ''
          vim.g.opencode_opts = {}
        '';
      };

      rest-nvim = {
        package = pkgs.vimPlugins.rest-nvim;
        setup = ''
          local ok, mod = pcall(require, 'rest-nvim')
          if ok then
            mod.setup({
              response = { hooks = { format = true } },
            })
          end
        '';
      };

      neotest = {
        package = pkgs.vimPlugins.neotest;
        setup = ''
          local ok, neotest = pcall(require, 'neotest')
          if ok then
            neotest.setup({
              adapters = { require('rustaceanvim.neotest') },
            })
          end
        '';
      };

      molten-nvim = {
        package = pkgs.vimPlugins.molten-nvim;
        setup = ''
          vim.g.molten_image_provider = "image.nvim"
        '';
      };
    };

    luaPackages = ["lua-utils-nvim" "nvim-nio" "pathlib-nvim" "xml2lua" "mimetypes"];

    extraPackages =
      [
        pkgs.universal-ctags
        pkgs.lldb
        pkgs.taplo
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [pkgs.d2]
      ++ [
        pkgs.sleek
        pkgs.graphqurl
        pkgs.sqls
        pkgs.lua
        pkgs.ripgrep
        pkgs.nodejs-slim
        pkgs.lsof
      ];

    luaConfigPost = ''
      vim.api.nvim_create_user_command('Reso',
        function()
          pcall(vim.cmd, 'source ~/.config/nvim/init.lua')
        end, {})

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
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
          pcall(vim.cmd, '%!${pkgs.sleek}/bin/sleek')
        end, {})

      vim.api.nvim_create_user_command('DapUiToggle',
        function()
          require('dapui').toggle()
        end, {})

      if vim.g.neovide then
        vim.o.guifont = "Hasklug Nerd Font Mono:h13"
        vim.g.neovide_cursor_vfx_mode = "railgun"
      end

      vim.filetype.add({
        extension = {
          slint = "slint",
          pest = "pest",
        },
        filename = {
          ['nurfile'] = "nu",
        },
      })

      vim.bo.formatexpr = "v:lua.require'conform'.formatexpr()"
    '';
  };
}
