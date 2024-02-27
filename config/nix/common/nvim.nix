{ pkgs, inputs, ... }: {
  imports = [ inputs.nixneovim.nixosModules.default ];
  programs.nixneovim = {
    enable = true;
    extraConfigLua = ''
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
    '';
    options = {
      number = true;
      relativenumberr = true;
    };
    plugins = {
      lspconfig = {
        enable = true;
        servers = {
          rust-analyzer.enable = true;
          nil.enable = true;
        };
      };
      treesitter = {
        enable = true;
        indent = true;
      };
    };
    colorschemes = {
      catppuccin = {
        enable = true;
        flavour = "mocha";
      };
    };
    mappings = {
      normal = {
        "<leader>ff" = "require'telescope.builtin'.find_files()";
        "<leader>gg" = "require'telescope.builtin'.live_grep()";
        "<leader>;" = "require'telescope.builtin'.buffers()";
        "<leader><leader>" = "<c-^>";
        "vff" = "<cmd>vertical Gdiffsplit<cr>";
        "<C-k>" = "vim.lsp.buf.definition()";
        "gi" = "vim.lsp.buf.implementation()";
        "<leader>a" = "vim.lsp.buf.code_action()";
        "F" = "vim.lsp.buf.format( async = true )";
      };
    };
  };
}
