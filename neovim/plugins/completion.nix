let
  inherit (import ../lib.nix) rawLua;
in {
  copilot-lua = {
    enable = false;
    settings = {
      panel = {
        enabled = false;
      };
      suggestion = {
        enabled = true;
        auto_trigger = true;
        keymap = {
          accept = "<C-l>";
        };
      };
    };
  };

  blink-cmp = {
    enable = true;
    settings = {
      completion = {
        documentation.window.border = "rounded";
        menu.border = "rounded";
        menu.draw.columns = [
          (rawLua ''{ "kind_icon", "label", "label_description", gap = 1 }'')
          (rawLua ''{ "source_name" }'')
        ];
      };
      signature = {
        window.border = "rounded";
      };
      keymap = {
        "<CR>" = ["select_and_accept" "fallback"];
        "<C-n>" = [
          "select_next"
          "fallback"
        ];
        "<C-p>" = [
          "select_prev"
          "fallback"
        ];
        "<C-u>" = [
          "scroll_documentation_up"
          "fallback"
        ];
        "<C-d>" = [
          "scroll_documentation_down"
          "fallback"
        ];
      };
      sources = {
        cmdline = [];
        # default =
        # rawLua
        # /*
        # lua
        # */
        # ''
        #   function(ctx)
        #     local success, node = pcall(vim.treesitter.get_node)
        #     if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
        #       return { 'buffer' }
        #     else
        #       return { 'git', 'lsp', 'path', 'snippets', 'buffer', 'dictionary', 'ripgrep', 'tmux' }
        #     end
        #   end
        # '';
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
          "ctags"
        ];
        per_filetype = {
          nix = rawLua ''{ inherit_defaults = true, "nixpkgs-maintainers" }'';
          tex = rawLua ''{ inherit_defaults = true, "latex" }'';
          markdown = rawLua ''{ inherit_defaults = true, "latex", "thesaurus" }'';
          gitcommit = rawLua ''{ inherit_defaults = true, "thesaurus" }'';
        };
        providers = {
          buffer = {
            score_offset = -7;
          };
          lsp = {
            fallbacks = [];
          };
          path = {};
          dictionary = {
            module = "blink-cmp-dictionary";
            name = "dict";
            min_keyword_length = 3;
            opts = {
            };
          };
          git = {
            module = "blink-cmp-git";
            name = "git";
            opts = {
              # -- options for the blink-cmp-git
            };
          };
          ripgrep = {
            module = "blink-ripgrep";
            name = "ripgrep";
            opts = {};
          };
          emoji = {
            module = "blink-emoji";
            name = "Emoji";
            score_offset = -5;
            min_keyword_length = 2;
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
          ctags = {
            module = "blink.compat.source";
            name = "ctags";
            score_offset = -4;
            min_keyword_length = 2;
            opts = {};
          };
          tmux = {
            module = "blink-cmp-tmux";
            name = "tmux";
            score_offset = -6;
            min_keyword_length = 3;
            opts = {
              triggered_only = false;
            };
          };
        };
      };
    };
  };
  blink-ripgrep.enable = true;
  blink-cmp-git.enable = true;
  blink-cmp-dictionary.enable = true;
  # blink-cmp-copilot.enable = true;
  blink-cmp-spell.enable = true;
  blink-emoji.enable = true;
  blink-cmp-words.enable = true;
  blink-cmp-nixpkgs-maintainers.enable = true;
  blink-cmp-latex.enable = true;
  blink-compat = {
    enable = true;
    settings.impersonate_nvim_cmp = true;
  };
}
