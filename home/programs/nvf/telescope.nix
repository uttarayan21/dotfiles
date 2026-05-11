{pkgs, ...}: {
  programs.nvf.settings.vim = {
    telescope = {
      enable = true;
      setupOpts.defaults = {
        layout_strategy = "horizontal";
        layout_config = {
          width = 0.9;
          height = 0.9;
        };
      };

      extensions = [
        {
          name = "undo";
          packages = [pkgs.vimPlugins.telescope-undo-nvim];
        }
        {
          name = "file_browser";
          packages = [pkgs.vimPlugins.telescope-file-browser-nvim];
        }
      ];
    };

    fzf-lua = {
      enable = true;
      setupOpts = {
        fzf_opts."--layout" = "default";
        winopts = {
          height = 0.9;
          width = 0.9;
        };
      };
    };
  };
}
