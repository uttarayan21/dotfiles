{pkgs}: let
  inherit (import ../lib.nix) rawLua;
in {
  rustaceanvim = {
    enable = true;
    settings = {
      server = {
        on_attach =
          rawLua
          # lua
          ''
            function(client, bufnr)
                vim.keymap.set(
                  "n",
                  "<leader>a",
                  function()
                    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
                    -- or vim.lsp.buf.codeAction() if you don't want grouping.
                  end,
                  { silent = true, buffer = bufnr }
                )
                vim.keymap.set(
                  "n",
                  "K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
                  function()
                    vim.cmd.RustLsp({'hover', 'actions'})
                  end,
                  { silent = true, buffer = bufnr }
                )
            end
          '';
        default_settings = {
          rust-analyzer = {
            inlayHints = {
              genericParameterHints = {
                lifetime.enable = true;
              };
              # implicitDrops.enable = true;
            };
            files = {
              excludeDirs = [
                ".cargo/"
                ".direnv/"
                ".git/"
                ".vcpkg/"
                "node_modules/"
                "target/"
              ];
            };
            diagnostics = {
              enable = true;
              styleLints.enable = true;
            };

            checkOnSave = true;
            check = {
              command = "check";
              features = "all";
            };
          };
        };
      };
      dap = let
        vscode-lldb = pkgs.vscode-extensions.vadimcn.vscode-lldb;
        liblldb =
          if pkgs.stdenv.isLinux
          then "${vscode-lldb.lldb}/lib/liblldb.so"
          else if pkgs.stdenv.isDarwin
          then "${vscode-lldb.lldb}/lib/liblldb.dylib"
          else null;
        codelldb = "${vscode-lldb.adapter}/bin/codelldb";
      in {
        autoload_configurations = false;
        adapter =
          /*
          lua
          */
          ''
            require('rustaceanvim.config').get_codelldb_adapter("${codelldb}", "${liblldb}")
          '';
      };
      tools = {
        float_win_config = {
          border = "rounded";
        };
        enable_clippy = false;
      };
    };
  };
}
