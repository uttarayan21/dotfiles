{inputs, ...}: let
  vimPlugins = final: prev: {
    vimPlugins =
      prev.vimPlugins
      // {
        d2 = final.pkgs.vimUtils.buildVimPlugin {
          name = "d2";
          version = "1";
          src = inputs.d2;
        };
      };
  };
  tree-sitter-grammars = final: prev: {
    tree-sitter-grammars =
      prev.tree-sitter-grammars
      // {
        tree-sitter-just = final.pkgs.tree-sitter.buildGrammar {
          language = "just";
          version = "1";
          src = inputs.tree-sitter-just;
        };
        tree-sitter-d2 = final.pkgs.tree-sitter.buildGrammar {
          language = "d2";
          version = "1";
          src = inputs.tree-sitter-d2;
        };
        tree-sitter-nu = final.pkgs.tree-sitter.buildGrammar {
          language = "nu";
          version = "1";
          src = inputs.tree-sitter-nu;
        };
      };
  };
in [
  inputs.nno.overlays.default
  inputs.nixvim.overlays.default
  vimPlugins
  tree-sitter-grammars
]
