{
  vim-surround.enable = true;
  ts-context-commentstring.enable = true;

  opencode = {
    enable = true;
  };

  # sidekick = {
  #   enable = true;
  #   settings = {
  #     nes = {
  #       enabled = false;
  #     };
  #   };
  # };

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
          neorg_leader = "<C-i>";
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
}
