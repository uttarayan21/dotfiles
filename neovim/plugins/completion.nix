{
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
          # "tmux"
        ];
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
          # tmux = {
          #   module = "blink-cmp-tmux";
          #   name = "tmux";
          #   opts = {
          #     triggered_only = false;
          #   };
          # };
        };
      };
    };
  };
  blink-ripgrep.enable = true;
  blink-cmp-git.enable = true;
  blink-cmp-dictionary.enable = true;
  # blink-cmp-copilot.enable = true;
  blink-cmp-spell.enable = true;
  blink-cmp-tmux.enable = true;
  blink-compat = {
    enable = true;
    settings.impersonate_nvim_cmp = true;
  };
}
