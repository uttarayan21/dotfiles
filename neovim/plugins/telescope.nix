{
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

  tv = {
    enable = true;
    settings = {
      global_keybindings = {
        channels = "<leader>tv";
      };
    };
  };
}
