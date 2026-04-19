{pkgs}: {
  lsp = {
    enable = true;
    servers = {
      taplo.enable = true;
      gopls.enable = true;
      nil_ls = {
        enable = true;
        settings = {
          formatting.command = [
            "${pkgs.alejandra}/bin/alejandra"
          ];
          nix.flake.autoArchive = true;
        };
      };
      # marksman.enable = true;
      neocmake.enable = true;
      nushell.enable = true;
      clangd.enable = true;
      lua_ls.enable = true;
      jsonls.enable = true;
      html.enable = true;
      htmx.enable = true;
      elixirls.enable = true;
      ast_grep.enable = true;
      sqls.enable = true;
      pyright.enable = true;
      slint_lsp.enable = true;
      wgsl_analyzer.enable = true;
      glsl_analyzer.enable = true;
      # sourcekit.enable = true;
      openscad_lsp.enable = true;
      tinymist.enable = true;
      # rust_analyzer = {
      #   enable = false;
      #   installCargo = false;
      #   installRustc = false;
      #   settings = {
      #     inlayHints = {
      #       typeHints.enable = false;
      #     };
      #     check = {
      #       features = ["default"];
      #     };
      #     files.exclude = [
      #       ".cargo/"
      #       ".direnv/"
      #       ".git/"
      #       ".vcpkg/"
      #       "node_modules/"
      #       "target/"
      #       "vendor/"
      #     ];
      #   };
      # };
    };
    # onAttach =
    #   /*
    #   lua
    #   */
    #   ''
    #     if client.server_capabilities.inlayHintProvider then
    #         vim.lsp.inlay_hint.enable(true)
    #     end
    #   '';
  };
}
