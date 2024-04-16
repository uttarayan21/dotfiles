{inputs, ...}: let
  vimPlugins = final: prev: {
    vimPlugins =
      prev.vimPlugins
      // {
        comfortable-motion = final.pkgs.vimUtils.buildVimPlugin {
          name = "comfortable-motion";
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "yuttie";
            repo = "comfortable-motion.vim";
            rev = "master";
            sha256 = "sha256-S1LJXmShhpCJIg/FEPx3jFbmPpS/1U4MAQN2RY/nkI0";
          };
        };
        nvim-dap-rr = final.pkgs.vimUtils.buildVimPlugin {
          name = "nvim-dap-rr";
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "jonboh";
            repo = "nvim-dap-rr";
            rev = "master";
            sha256 = "sha256-JNztLTSyHmEmh3xT4WR0cpP25vjZ4A6aQbnU49U6+Ss";
          };
        };
        sqls-nvim = final.pkgs.vimUtils.buildVimPlugin {
          name = "sqls-nvim";
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "nanotee";
            repo = "sqls.nvim";
            rev = "master";
            sha256 = "sha256-jKFut6NZAf/eIeIkY7/2EsjsIhvZQKCKAJzeQ6XSr0s";
          };
        };
        outline-nvim = final.pkgs.vimUtils.buildVimPlugin {
          name = "outline-nvim";
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "hedyhli";
            repo = "outline.nvim";
            rev = "master";
            sha256 = "sha256-HaxfnvgFy7fpa2CS7/dQhf6dK9+Js7wP5qGdIeXLGPY";
          };
        };
        nvim-devdocs = final.pkgs.vimUtils.buildVimPlugin {
          pname = "nvim-devdocs";
          version = "0.4.1";
          src = inputs.nvim-devdocs;
        };
        neorg = final.vimUtils.buildVimPlugin {
          pname = "neorg";
          version = inputs.neorg.rev;
          src = inputs.neorg;
          dependencies = [final.vimPlugins.plenary-nvim];
          # final.lua51Packages.lua-utils-nvim final.vimPlugins.nvim-nio final.vimPlugins.nui-nvim;
        };
        neorg-telescope = final.vimUtils.buildVimPlugin {
          pname = "neorg-telescope";
          version = inputs.neorg-telescope.rev;
          src = inputs.neorg-telescope;
          dependencies = [final.vimPlugins.telescope-nvim final.vimPlugins.neorg];
        };
      };
  };
  tree-sitter-grammars = final: prev: {
    tree-sitter-grammars =
      prev.tree-sitter-grammars
      // {
        tree-sitter-just = final.pkgs.tree-sitter.buildGrammar {
          language = "just";
          version = "1";
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "IndianBoy42";
            repo = "tree-sitter-just";
            rev = "613b3fd39183bec94bc741addc5beb6e6f17969f";
            sha256 = "sha256-OBlXwWriE6cdGn0dhpfSMnJ6Rx1Z7KcXehaamdi/TxQ";
          };
        };
        tree-sitter-nu = final.pkgs.tree-sitter.buildGrammar {
          language = "nu";
          version = "0.0.1";
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "nushell";
            repo = "tree-sitter-nu";
            rev = "c5b7816043992b1cdc1462a889bc74dc08576fa6";
            sha256 = "sha256-P+ixE359fAW7R5UJLwvMsmju7UFmJw5SN+kbMEw7Kz0=";
          };
        };
      };
  };
  rest-nvim-overlay = final: prev: let
    # TODO: Move to subflake
    rest-nvim-src = final.pkgs.fetchFromGitHub {
      owner = "rest-nvim";
      repo = "rest.nvim";
      # rev = "64175b161b61b6807b4c6f3f18dd884325cf04e0";
      # Before v2 release
      rev = "v1.0.0";
      # sha256 = "sha256-3EC0j/hEbdQ8nJU0I+LGmE/zNnglO/FrP/6POer0338";
      # sha256 = "sha256-3EC0j/hEbdQ8nJU0I+LGmE/zNnglO/FrP/6POer0339";
      sha256 = "sha256-jSY5WXx5tQAD0ZefPbg2luHywGAMcB9wdUTy6Av3xnY";
    };
  in {
    vimPlugins =
      prev.vimPlugins
      // {
        rest-nvim = final.vimUtils.buildVimPlugin {
          pname = "rest.nvim";
          version = "1.0.0";
          src = rest-nvim-src;
          # version = "scm-1";
          # rockspecVersion = "0.2-1";
          # buildInputs = with final.pkgs.lua51Packages; [lua lua-curl mimetypes nvim-nio xml2lua];
        };
      };
  };
in [
  inputs.nnn.overlay
  inputs.nixvim.overlays.default
  vimPlugins
  tree-sitter-grammars
  rest-nvim-overlay
]
