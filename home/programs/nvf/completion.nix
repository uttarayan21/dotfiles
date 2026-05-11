{
  lib,
  pkgs,
  ...
}: let
  inline = lib.generators.mkLuaInline;
in {
  programs.nvf.settings.vim.autocomplete.blink-cmp = {
    enable = true;

    sourcePlugins = {
      emoji.enable = true;
      ripgrep.enable = true;
      spell.enable = true;
    };

    setupOpts = {
      completion = {
        documentation.window.border = "rounded";
        menu.border = "rounded";
        menu.draw.columns = [
          (inline ''{ "kind_icon", "label", "label_description", gap = 1 }'')
          (inline ''{ "source_name" }'')
        ];
      };
      signature.window.border = "rounded";

      keymap = {
        preset = "none";
        "<CR>" = ["select_and_accept" "fallback"];
        "<C-n>" = ["select_next" "fallback"];
        "<C-p>" = ["select_prev" "fallback"];
        "<C-u>" = ["scroll_documentation_up" "fallback"];
        "<C-d>" = ["scroll_documentation_down" "fallback"];
      };

      cmdline.sources = [];
      sources = {
        default = [
          "git"
          "lsp"
          "dictionary"
          "snippets"
          "path"
          "buffer"
          "ripgrep"
          "emoji"
          "tmux"
        ];
        per_filetype = {
          nix = inline ''{ inherit_defaults = true, "nixpkgs-maintainers" }'';
          tex = inline ''{ inherit_defaults = true, "latex" }'';
          markdown = inline ''{ inherit_defaults = true, "latex", "thesaurus" }'';
          gitcommit = inline ''{ inherit_defaults = true, "thesaurus" }'';
        };
        providers = {
          buffer.score_offset = -7;
          lsp.fallbacks = [];
          dictionary = {
            module = "blink-cmp-dictionary";
            name = "dict";
            min_keyword_length = 3;
            opts = {};
          };
          git = {
            module = "blink-cmp-git";
            name = "git";
            opts = {};
          };
          thesaurus = {
            module = "blink-cmp-words.thesaurus";
            name = "blink-cmp-words";
            score_offset = -8;
            min_keyword_length = 3;
            opts = {};
          };
          nixpkgs-maintainers = {
            module = "blink_cmp_nixpkgs_maintainers";
            name = "nixpkgs maintainers";
            score_offset = -3;
            min_keyword_length = 2;
            opts = {};
          };
          latex = {
            module = "blink-cmp-latex";
            name = "Latex";
            score_offset = -5;
            min_keyword_length = 2;
            opts = {};
          };
          tmux = {
            module = "blink-cmp-tmux";
            name = "tmux";
            score_offset = -6;
            min_keyword_length = 3;
            opts.triggered_only = false;
          };
        };
      };
    };
  };

  # Source providers not exposed as nvf sourcePlugins — pull in via extraPlugins
  programs.nvf.settings.vim.extraPlugins = {
    blink-cmp-git.package = pkgs.vimPlugins.blink-cmp-git;
    blink-cmp-dictionary.package = pkgs.vimPlugins.blink-cmp-dictionary;
    blink-cmp-words.package = pkgs.vimPlugins.blink-cmp-words;
    blink-cmp-nixpkgs-maintainers.package = pkgs.vimPlugins.blink-cmp-nixpkgs-maintainers;
    blink-cmp-latex.package = pkgs.vimPlugins.blink-cmp-latex;
    blink-cmp-tmux.package = pkgs.vimPlugins.blink-cmp-tmux;
    blink-compat.package = pkgs.vimPlugins.blink-compat;
  };
}
