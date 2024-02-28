{ pkgs, inputs, ... }: {
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
      # "opt.list" = true;
      wrap = true;
    };

    globals = {
      mapleader = " ";
      #copilot_no_tab_map = true;
    };
    plugins = {
      lspconfig = {
        enable = true;
        servers = {
          nil = {
            enable = true;
            extraConfig = ''
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
          lua-language-server = {
            enable = true;
            onAttachExtra = ''
              local lspconfig = require 'lspconfig'
              local lsp_zero = require'lsp-zero'
              local lua_opts = lsp_zero.nvim_lua_ls()
              lspconfig.lua_ls.setup(lua_opts)
            '';
          };
        };
        onAttach = ''
          vim.lsp.inlay_hint.enable(bufnr, true)
        '';
      };

      todo-comments.enable = true;
      lualine.enable = true;
      commentary.enable = true;
      surround.enable = true;

      treesitter = {
        enable = true;
        indent = true;
      };
      telescope = {
        enable = true;
        extensions = {
          manix.enable = true;
          # plenary.enable = true;
        };
      };

      nvim-cmp = {
        enable = true;
        completion = {
          completeopt = "menu,menuone,popup,noselect";
        };
        sources = {
          nvim_lsp.enable = true;
          luasnip.enable = true;
          buffer.enable = true;
          path.enable = true;
          cmdline.enable = true;
          #copilot.enable = true;
          git.enable = true;
        };
        snippet.luasnip.enable = true;
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
        "<leader>mm" = "require'telescope-manix'.search";
        "<leader>;" = "require'telescope.builtin'.buffers";
        "<leader><leader>" = "'<c-^>'";
        "vff" = "'<cmd>vertical Gdiffsplit<cr>'";
        "<C-k>" = "vim.lsp.buf.definition";
        "gi" = "vim.lsp.buf.implementation";
        "<leader>a" = "vim.lsp.buf.code_action";
        "F" = "function() vim.lsp.buf.format({ async = true }) end";
        # "<C-l>" = ''copilot#Accept("<CR>")'';
      };
    };

    extraPlugins =
      let
        comfortable-motion = pkgs.fetchFromGitHub {
          owner = "yuttie";
          repo = "comfortable-motion.vim";
          rev = "master";
          sha256 = "sha256-S1LJXmShhpCJIg/FEPx3jFbmPpS/1U4MAQN2RY/nkI0";
        };
      in
      [
        comfortable-motion
        pkgs.vimExtraPlugins.rustaceanvim
        pkgs.vimExtraPlugins.cmp-nvim-lsp
        pkgs.vimExtraPlugins.fidget-nvim
        pkgs.vimExtraPlugins.rest-nvim
        pkgs.vimExtraPlugins.lsp-zero-nvim
        pkgs.vimPlugins.vim-abolish
      ];
  };
}
