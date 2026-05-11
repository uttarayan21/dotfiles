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
      file-browser.enable = true;
    };
  };

  fzf-lua = {
    enable = true;
    settings = {
      fzf_opts = {
        "--layout" = "default";
      };
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
