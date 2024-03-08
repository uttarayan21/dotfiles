{ pkgs, config, inputs, ... }: {
  imports = [ inputs.nixneovim.nixosModules.default ];
  programs.nixneovim = {
    enable = true;
    options = {
      foldexpr = "nvim_treesitter#foldexpr()";
      foldmethod = "expr";
      number = true;
      relativenumber = true;
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      hidden = true;
      smartcase = true;
      termguicolors = true;
      signcolumn = "yes";
      wrap = true;
      completeopt = "menu,menuone,popup,noselect";
      undodir = "${config.xdg.cacheHome}/undodir";
      undofile = true;
    };

    globals = { mapleader = " "; };
    plugins = {
      lspconfig = {
        enable = true;
        servers = {
          nil = {
            enable = true;
            extraConfig =
              /* lua */
              ''
                settings = {
                  ['nil'] = {
                    formatting = {
                      command = { "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" },
                    },
                    nix = {
                      flake = {
                          autoArchive = true,
                      },
                    },
                  },
                },
              '';
          };
          lua-language-server.enable = true;
          jsonls.enable = true;
          html.enable = true;
          pylyzer.enable = true;
          sqls = {
            enable = true;
            onAttachExtra =
              /* lua */
              ''
                require('sqls').on_attach(client, bufnr)
              '';
          };
          # rust-analyzer.enable = true;
        };
        extraLua.pre =
          # lua
          ''
            local lsp_zero = require'lsp-zero'
            local lspconfig = require 'lspconfig'
            lsp_zero.on_attach(function(client, bufnr)
              lsp_zero.default_keymaps({buffer = bufnr})
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(bufnr, true)
                end
            end)
          '';
        # extraLua.post = ''
        #   vim.lsp.inlay_hint.enable(bufnr, true)
        # '';
      };

      nvim-dap.enable = true;
      todo-comments.enable = true;
      lualine = { enable = true; };
      commentary.enable = true;
      surround.enable = true;
      which-key.enable = true;
      ufo.enable = true;
      fugitive.enable = true;
      markdown-preview = {
        enable = true;
        autoStart = true;
      };
      ts-context-commentstring.enable = true;

      treesitter = {
        enable = true;
        indent = true;
        folding = true;
        refactor = {
          smartRename = {
            enable = true;
            keymaps = { smartRename = "<leader>rn"; };
          };
        };
      };

      mini = {
        enable = true;
        ai.enable = true;
        # pairs.enable = true;
        # cursorword.enable = true;
        starter.enable = true;
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
        "<leader>ff" = "require'telescope.builtin'.find_files";
        "<leader>gg" = "require'telescope.builtin'.live_grep";
        "<leader>;" = "require'telescope.builtin'.buffers";
        "<leader>o" = "[[<cmd>TroubleToggle<cr>]]";
        "<leader>ee" = "require'rest-nvim'.run";
        "<leader>ec" = "function() require'rest-nvim'.run(true) end";
        # "<leader>ee" = "[[<Plug>RestNvim]]";
        # "<leader>ec" = "[[<Plug>RestNvimPreview]]";
        # "<leader>el" = "require('telescope').extensions.rest.select_env";
        "<leader>\\\"" = ''[["+]]'';
        "vff" = "[[<cmd>vertical Gdiffsplit<cr>]]";
        "<C-k>" = "vim.lsp.buf.definition";
        "gi" = "vim.lsp.buf.implementation";
        "<leader>a" = "vim.lsp.buf.code_action";
        "F" = "function() vim.lsp.buf.format({ async = true }) end";
        "<leader><leader>" = "'<c-^>'";
        "<leader>q" = "[[<cmd>bw<cr>]]";
        "<leader>n" = "[[<cmd>bnext<cr>]]";
        "<leader>p" = "[[<cmd>bprev<cr>]]";

        "<C-l>" = "[[<cmd>Outline<cr>]]";
        "<C-\\\\>" = "require('FTerm').toggle";
      };
      terminal = {
        "<C-\\\\>" = "require('FTerm').toggle";
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      comfortable-motion
      vim-abolish
      telescope-nvim
      telescope-ui-select-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      telescope-dap-nvim
      rustaceanvim

      # Treesitter stuff
      outline-nvim

      # lsp stuff
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp_luasnip
      cmp-tmux
      cmp-treesitter
      luasnip
      fidget-nvim
      copilot-lua
      lsp-zero-nvim
      trouble-nvim
      crates-nvim
      sqls-nvim

      # No more postman
      rest-nvim

      # UI
      noice-nvim
      nvim-web-devicons

      # Utils
      FTerm-nvim
      plenary-nvim

    ];
    extraConfigLua = builtins.readFile ./extraConfig.lua;
    package = pkgs.neovim-nightly;
  };
}

