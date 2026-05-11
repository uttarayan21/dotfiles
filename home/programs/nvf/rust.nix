{
  programs.nvf.settings.vim.languages.rust = {
    enable = true;
    lsp = {
      enable = true;
      opts = ''
        ['rust-analyzer'] = {
          inlayHints = {
            genericParameterHints = {
              lifetime = { enable = true },
            },
          },
          files = {
            excludeDirs = {
              ".cargo/",
              ".direnv/",
              ".git/",
              ".vcpkg/",
              "node_modules/",
              "target/",
            },
          },
          diagnostics = {
            enable = true,
            styleLints = { enable = true },
          },
          checkOnSave = true,
          check = {
            command = "check",
            features = "all",
          },
        },
      '';
    };
    dap = {
      enable = true;
      adapter = "codelldb";
    };
    extensions.crates-nvim.enable = true;
  };
}
