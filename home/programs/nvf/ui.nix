{lib, ...}: let
  inline = lib.generators.mkLuaInline;
in {
  programs.nvf.settings.vim = {
    statusline.lualine.enable = true;

    visuals = {
      nvim-web-devicons.enable = true;
      fidget-nvim = {
        enable = true;
        setupOpts.notification.override_vim_notify = true;
      };
    };

    ui = {
      noice = {
        enable = true;
        setupOpts = {
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

      nvim-ufo = {
        enable = true;
        setupOpts.provider_selector = inline ''
          function(bufnr, filetype, buftype)
            return {'treesitter', 'indent'}
          end
        '';
      };
    };

    mini = {
      ai.enable = true;
      starter.enable = true;
    };

    binds.whichKey.enable = true;

    lsp.trouble.enable = true;

    notes.todo-comments.enable = true;
  };
}
