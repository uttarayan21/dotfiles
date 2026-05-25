{lib, ...}: let
  # Preserve the original nixvim authoring style: a per-mode attrset where
  # values are raw Lua expressions. `[[…]]` Lua long-strings yield plain rhs
  # strings (vim-cmd actions); bare expressions like `require'fzf-lua'.files`
  # yield function references. Both work as vim.keymap.set rhs.
  mkMaps = byMode:
    lib.concatLists (lib.mapAttrsToList (
        mode: maps:
          lib.mapAttrsToList (key: action: {
            inherit key action mode;
            lua = true;
          })
          maps
      )
      byMode);
in {
  programs.nvf.settings.vim.keymaps = mkMaps {
    n = {
      "<C-l>" = "[[<cmd>Outline<cr>]]";
      "<C-w>\"" = "[[<cmd>split<cr>]]";
      "<C-w>%" = "[[<cmd>vsplit<cr>]]";
      "gh" = "[[<cmd>Octo actions<cr>]]";
      "<leader>\"" = ''[["+]]'';
      "<leader>dr" = "[[<cmd>RustLsp debuggables<cr>]]";
      "<leader>ee" = "[[<cmd>Rest run<cr>]]";
      "<leader>el" = "[[<cmd>Rest run last<cr>]]";
      "<leader><leader>" = "'<c-^>'";
      "<leader>n" = "[[<cmd>bnext<cr>]]";
      "<leader>o" = "[[<cmd>Trouble diagnostics<cr>]]";
      "<leader>p" = "[[<cmd>bprev<cr>]]";
      "<leader>q" = "[[<cmd>bw<cr>]]";
      "<leader>mm" = "[[<cmd>Neorg<cr>]]";
      "vff" = "[[<cmd>vertical Gdiffsplit<cr>]]";

      "<leader>rn" = "vim.lsp.buf.rename";
      "<C-k>" = "vim.lsp.buf.definition";
      "<C-\\>" = "require('FTerm').toggle";
      "F" = "require('conform').format";
      "gi" = "require'fzf-lua'.lsp_references";
      "<leader>a" = "vim.lsp.buf.code_action";
      "<leader>bb" = "require'dap'.toggle_breakpoint";
      "<leader>du" = "require'dapui'.toggle";
      "<leader>fb" = "require'telescope'.extensions.file_browser.file_browser";
      "<leader>fg" = "require'yazi'.yazi";
      "<leader>ff" = "require'fzf-lua'.files";
      "<leader>gg" = "require'fzf-lua'.live_grep";
      "<leader>;" = "require'fzf-lua'.buffers";
      "<leader>gs" = "require'fzf-lua'.git_status";
      "<leader>:" = "require'fzf-lua'.command_history";
      "<leader>fh" = "require'fzf-lua'.helptags";
      "zR" = "require'ufo'.openAllFolds";
      "zM" = "require'ufo'.closeAllFolds";
      "<C-.>" = "require('opencode').toggle";

      # Emulate tmux bindings with prefix <C-q> and tabs
      "<C-q><C-q>" = "[[g<Tab>]]";
      "<C-q>c" = "[[<cmd>tabnew<cr>]]";
      "<C-q>x" = "[[<cmd>tabclose<cr>]]";
      "<C-q>n" = "[[<cmd>tabnext<cr>]]";
      "<C-q>p" = "[[<cmd>tabprevious<cr>]]";
    };

    t = {
      "<C-\\>" = "require('FTerm').toggle";
    };

    i = {
      "<C-\\>" = "require('FTerm').toggle";
    };

    v = {
      "L" = "[[:'<,'>!sort -u<cr>]]";
    };
  };
}
