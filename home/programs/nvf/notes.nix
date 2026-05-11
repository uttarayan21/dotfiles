{
  programs.nvf.settings.vim.notes.neorg = {
    enable = true;
    setupOpts.load = {
      "core.defaults" = {};
      "core.completion".config = {
        engine = "nvim-cmp";
        name = "[Norg]";
      };
      "core.concealer".config.icon_preset = "diamond";
      "core.keybinds".config = {
        default_keybinds = true;
        neorg_leader = "<C-i>";
      };
      "core.integrations.treesitter".config = {
        install_parsers = false;
        configure_parsers = false;
      };
      "core.dirman".config = {
        default_workspace = "Notes";
        workspaces = {
          Notes = "~/Nextcloud/Notes";
          Work = "~/Nextcloud/Work";
        };
      };
    };
  };
}
