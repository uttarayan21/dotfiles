{pkgs}: let
  inherit (import ./lib.nix) rawLua;
  mkMappings = mappings:
    []
    ++ (pkgs.lib.optionals (builtins.hasAttr "normal" mappings) (mkMode mappings.normal "n"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "terminal" mappings) (mkMode mappings.terminal "t"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "insert" mappings) (mkMode mappings.insert "i"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "visual" mappings) (mkMode mappings.visual "v"))
    ++ (pkgs.lib.optionals (builtins.hasAttr "global" mappings) (mkMode mappings.global ""));
  mkMode = mappings: mode:
    pkgs.lib.mapAttrsToList (key: value: {
      key = key;
      action = rawLua value;
      mode = mode;
    })
    mappings;
in {
  keymaps = mkMappings {
    normal = {
      "<C-l>" = "[[<cmd>Outline<cr>]]";
      "<C-w>\"" = "[[<cmd>split<cr>]]";
      "<C-w>%" = "[[<cmd>vsplit<cr>]]";
      "gh" = "[[<cmd>Octo actions<cr>]]";
      "<leader>\"" = ''[["+]]'';
      "<C-c>" = "[[<cmd>ChatGPT<cr>]]";
      "<leader>dr" = "[[<cmd>RustLsp debuggables<cr>]]";
      "<leader>ee" = "[[<cmd>Rest run<cr>]]";
      "<leader>el" = "[[<cmd>Rest run last<cr>]]";
      "<leader>hh" = "[[<cmd>DevdocsOpen<cr>]]";
      "<leader>hl" = "[[<cmd>DevdocsToggle<cr>]]";
      "<leader><leader>" = "'<c-^>'";
      "<leader>n" = "[[<cmd>bnext<cr>]]";
      "<leader>o" = "[[<cmd>Trouble diagnostics<cr>]]";
      "<leader>p" = "[[<cmd>bprev<cr>]]";
      "<leader>q" = "[[<cmd>bw<cr>]]";
      "<leader>mm" = "[[<cmd>Neorg<cr>]]";
      "vff" = "[[<cmd>vertical Gdiffsplit<cr>]]";

      "<leader>rr" = "vim.lsp.buf.rename";
      "<C-k>" = "vim.lsp.buf.definition";
      "<C-\\>" = "require('FTerm').toggle";
      # "F" = "function() vim.lsp.buf.format({ async = true }) end";
      "F" = "require('conform').format";
      "gi" = "require'telescope.builtin'.lsp_references";
      "<leader>a" = "vim.lsp.buf.code_action";
      "<leader>bb" = "require'dap'.toggle_breakpoint";
      "<leader>du" = "require'dapui'.toggle";
      "<leader>fb" = "require'telescope'.extensions.file_browser.file_browser";
      "<leader>fg" = "require'yazi'.yazi";
      "<leader>ff" = "require'telescope.builtin'.find_files";
      "<leader>gg" = "require'telescope.builtin'.live_grep";
      "<leader>;" = "require'telescope.builtin'.buffers";
      "zR" = "require'ufo'.openAllFolds";
      "zM" = "require'ufo'.closeAllFolds";

      # Emulate tmux bindings with prefix <C-q> and tabs
      "<C-q><C-q>" = "[[g<Tab>]]";
      "<C-q>c" = "[[<cmd>tabnew<cr>]]";
      "<C-q>x" = "[[<cmd>tabclose<cr>]]";
      "<C-q>n" = "[[<cmd>tabnext<cr>]]";
      "<C-q>p" = "[[<cmd>tabprevious<cr>]]";
      "<C-.>" = "require('opencode').toggle";
    };
    terminal = {
      "<C-\\>" = "require('FTerm').toggle";
    };
    insert = {
      "<C-\\>" = "require('FTerm').toggle";
    };
    visual = {
      "L" = "[[:'<,'>!sort -u<cr>]]";
    };
  };

  autoCmd = [
    {
      event = [
        "BufEnter"
        "BufWinEnter"
      ];
      pattern = "*.norg";
      command = "set conceallevel=3";
    }
    {
      event = [
        "BufEnter"
        "BufWinEnter"
      ];
      pattern = "*.pest";
      command = "setlocal commentstring=//%s";
    }
    # {
    #   event = ["BufEnter" "BufWinEnter"];
    #   pattern = "*.sql";
    #   command = "nnoremap <buffer> F :Sqlfmt<cr>";
    # }
    {
      event = ["BufWinLeave"];
      pattern = "?*";
      command = "mkview!";
    }
    {
      event = ["BufWinEnter"];
      pattern = "?*";
      command = "silent! loadview!";
    }
    {
      event = ["FileType"];
      pattern = "json";
      callback =
        rawLua
        /*
        lua
        */
        ''
          function(ev)
              vim.bo[ev.buf].formatprg = "${pkgs.jq}/bin/jq"
          end
        '';
    }
  ];
}
