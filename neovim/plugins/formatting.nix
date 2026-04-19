{
  conform-nvim = {
    enable = true;
    settings = {
      format_on_save =
        # lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_format = "fallback" }
          end
        '';
      formatters_by_ft = {
        json = ["jq"];
        d2 = ["d2"];
        sql = ["sleek"];
        toml = ["taplo"];
        nix = ["alejandra"];
      };
    };
  };
}
