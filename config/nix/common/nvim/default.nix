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
          lua-language-server = { enable = true; };
        };
        extraLua.pre = ''
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

      todo-comments.enable = true;
      lualine.enable = true;
      commentary.enable = true;
      surround.enable = true;
      which-key.enable = true;

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
        "<leader>ff" = "require'telescope.builtin'.find_files";
        "<leader>gg" = "require'telescope.builtin'.live_grep";
        "<leader>;" = "require'telescope.builtin'.buffers";
        "<leader>\\\"" = ''[["+]]'';
        "<leader><leader>" = "'<c-^>'";
        "vff" = "'<cmd>vertical Gdiffsplit<cr>'";
        "<C-k>" = "vim.lsp.buf.definition";
        "gi" = "vim.lsp.buf.implementation";
        "<leader>a" = "vim.lsp.buf.code_action";
        "F" = "function() vim.lsp.buf.format({ async = true }) end";
        "<C-l>" = "'copilot#Accept(\"<CR>\")'";
        "<leader>q" = "[[<cmd>bw<cr>]]";
        "<leader>n" = "[[<cmd>bnext<cr>]]";
        "<leader>p" = "[[<cmd>bprev<cr>]]";
      };
    };

    extraPlugins = let
      comfortable-motion = pkgs.fetchFromGitHub {
        owner = "yuttie";
        repo = "comfortable-motion.vim";
        rev = "master";
        sha256 = "sha256-S1LJXmShhpCJIg/FEPx3jFbmPpS/1U4MAQN2RY/nkI0";
      };
    in [
      comfortable-motion
      pkgs.vimPlugins.vim-abolish
      pkgs.vimPlugins.telescope-nvim
      pkgs.vimPlugins.telescope-ui-select-nvim
      pkgs.vimPlugins.telescope-fzf-native-nvim
      pkgs.vimPlugins.telescope-file-browser-nvim
      pkgs.vimExtraPlugins.rustaceanvim

      pkgs.vimPlugins.nvim-cmp
      pkgs.vimPlugins.cmp-buffer
      pkgs.vimPlugins.cmp-path
      pkgs.vimPlugins.cmp-cmdline
      pkgs.vimPlugins.cmp-nvim-lsp
      pkgs.vimPlugins.cmp-nvim-lua

      pkgs.vimExtraPlugins.fidget-nvim
      pkgs.vimExtraPlugins.copilot-lua
      pkgs.vimExtraPlugins.lsp-zero-nvim
      pkgs.vimExtraPlugins.rest-nvim
    ];
    extraConfigLua = builtins.readFile ./extraConfig.lua;
    package = pkgs.neovim-nightly;
  };
}

