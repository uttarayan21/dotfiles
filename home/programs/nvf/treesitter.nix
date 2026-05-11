{pkgs, ...}: {
  programs.nvf.settings.vim.treesitter = {
    enable = true;
    fold = true;
    addDefaultGrammars = true;
    grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
      just
      nu
      slint
    ];
  };
}
