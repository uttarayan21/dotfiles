{
  web-devicons.enable = true;
  todo-comments.enable = true;
  trouble.enable = true;
  which-key.enable = true;

  lualine = {
    enable = true;
    # package = stablePkgs.vimPlugins.lualine-nvim;
  };

  mini = {
    enable = true;
    modules = {
      ai = {};
      starter = {};
    };
  };

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

  fidget = {
    enable = true;
    settings.notification.override_vim_notify = true;
  };

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
}
