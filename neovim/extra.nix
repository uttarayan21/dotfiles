{
  pkgs,
  lib,
  ...
}: {
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
    blink-cmp-tmux
    cmp-ctags
    nvim-cmp
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
  extraPackages =
    [
      pkgs.universal-ctags
      pkgs.lldb
      pkgs.taplo
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.d2
    ]
    ++ [
      pkgs.sleek
      pkgs.graphqurl
      pkgs.sqls
      pkgs.lua
      pkgs.ripgrep
      pkgs.nodejs-slim
      pkgs.lsof
    ];
}
