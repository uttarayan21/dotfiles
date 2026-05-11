{pkgs, ...}: {
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;
      formatOnSave = false;
      lspconfig.enable = true;

      servers = {
        htmx = {
          cmd = ["${pkgs.htmx-lsp}/bin/htmx-lsp"];
          filetypes = ["html"];
        };
        ast_grep = {
          cmd = ["${pkgs.ast-grep}/bin/ast-grep" "lsp"];
        };
        slint_lsp = {
          cmd = ["${pkgs.slint-lsp}/bin/slint-lsp"];
          filetypes = ["slint"];
        };
      };

      lspconfig.sources.nil-extra = ''
        vim.lsp.config["nil"] = vim.tbl_deep_extend("force", vim.lsp.config["nil"] or {}, {
          settings = {
            ["nil"] = {
              formatting = { command = { "${pkgs.alejandra}/bin/alejandra" } },
              nix = { flake = { autoArchive = true } },
            },
          },
        })
      '';
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableDAP = true;

      nix.enable = true;
      lua.enable = true;
      go.enable = true;
      html.enable = true;
      python = {
        enable = true;
        lsp.servers = ["pyright"];
      };
      sql.enable = true;
      toml.enable = true;
      typst.enable = true;
      clang.enable = true;
      json.enable = true;
      cmake.enable = true;
      nu.enable = true;
      elixir.enable = true;
      glsl.enable = true;
      wgsl.enable = true;
      openscad.enable = true;
    };
  };
}
