{inputs, ...}: let
  vimPlugins = final: prev: {
    vimPlugins =
      prev.vimPlugins
      // {
        d2 = final.pkgs.vimUtils.buildVimPlugin {
          name = "d2";
          version = "1";
          src = inputs.d2;
        };
        gp-nvim = final.pkgs.vimUtils.buildVimPlugin {
          name = "gp.nvim";
          src = inputs.gp-nvim;
        };
        neogit = final.pkgs.vimUtils.buildVimPlugin {
          name = "neogit";
          version = inputs.neogit.rev;
          src = inputs.neogit;
          dependencies = with final.vimPlugins; [plenary-nvim diffview-nvim fzf-lua];
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
        # neorg = final.vimUtils.buildVimPlugin {
        #   pname = "neorg";
        #   version = inputs.neorg.rev;
        #   src = inputs.neorg;
        #   dependencies = [final.vimPlugins.plenary-nvim];
        #   # final.lua51Packages.lua-utils-nvim final.vimPlugins.nvim-nio final.vimPlugins.nui-nvim;
        # };
        # neorg-telescope = final.vimUtils.buildVimPlugin {
        #   pname = "neorg-telescope";
        #   version = inputs.neorg-telescope.rev;
        #   src = inputs.neorg-telescope;
        #   dependencies = [final.vimPlugins.telescope-nvim final.vimPlugins.neorg];
        # };
        pets-nvim = final.pkgs.vimUtils.buildVimPlugin {
          pname = "pets-nvim";
          version = "1";
          src = inputs.pets;
          dependencies = [final.pkgs.vimPlugins.hologram-nvim final.pkgs.vimPlugins.nui-nvim];
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
          src = inputs.tree-sitter-just;
        };
        tree-sitter-d2 = final.pkgs.tree-sitter.buildGrammar {
          language = "d2";
          version = "1";
          src = inputs.tree-sitter-d2;
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
  # rest-nvim-overlay = final: prev: let
  #   rest-nvim-src = inputs.rest-nvim;
  #   rest-nvim-luaPackage-override = luaself: luaprev: {
  #     rest-nvim = luaself.callPackage (
  #       {
  #         luaOlder,
  #         buildLuarocksPackage,
  #         lua,
  #         nvim-nio,
  #         luarocks-nix,
  #         lua-curl,
  #         mimetypes,
  #         xml2lua,
  #       }:
  #         buildLuarocksPackage {
  #           pname = "rest.nvim";
  #           version = "scm-1";
  #           knownRockspec = "${rest-nvim-src}/rest.nvim-scm-1.rockspec";
  #           src = rest-nvim-src;
  #           propagatedBuildInputs = [lua luarocks-nix nvim-nio lua-curl mimetypes xml2lua];
  #           disable = luaOlder "5.1";
  #         }
  #     ) {};
  #   };
  #   lua5_1 = prev.lua5_1.override {
  #     packageOverrides = rest-nvim-luaPackage-override;
  #   };
  #   lua51Packages = final.lua5_1.pkgs;
  # in {
  #   inherit lua5_1 lua51Packages;
  #   # vimPlugins =
  #   #   prev.vimPlugins
  #   #   // {
  #   #     rest-nvim = final.neovimUtils.buildNeovimPlugin {
  #   #       pname = "rest.nvim";
  #   #       version = "scm-1";
  #   #       src = rest-nvim-src;
  #   #     };
  #   #   };
  #   # rest-nvim = final.vimPlugins.rest-nvim;
  # };
in [
  inputs.nno.overlays.default
  inputs.nnn.overlays.default
  inputs.nixvim.overlays.default
  vimPlugins
  tree-sitter-grammars
  # rest-nvim-overlay
]
