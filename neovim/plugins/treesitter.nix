{
  treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      highlight = {
        enable = true;
        additional_vim_regex_highlighting = true;
      };
    };
    folding.enable = true;
    # grammarPackages =
    #   (with pkgs.tree-sitter-grammars; [
    #     tree-sitter-norg
    #     tree-sitter-norg-meta
    #     tree-sitter-just
    #     tree-sitter-nu
    #     tree-sitter-pest
    #     tree-sitter-slint
    #   ])
    #   ++ pkgs.vimPlugins.nvim-treesitter.allGrammars;
    # nixGrammars = true;
  };
}
