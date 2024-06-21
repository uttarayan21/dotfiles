{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nno = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nnn = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pets = {
      url = "github:giusgad/pets.nvim";
      flake = false;
    };
    neorg = {
      url = "github:nvim-neorg/neorg/v7.0.0";
      flake = false;
    };
    neorg-telescope = {
      url = "github:nvim-neorg/neorg-telescope";
      flake = false;
    };
    rest-nvim = {
      url = "github:rest-nvim/rest.nvim";
      flake = false;
    };
    gp-nvim = {
      url = "github:Robitx/gp.nvim";
      flake = false;
    };
    nvim-devdocs = {
      url = "github:luckasRanarison/nvim-devdocs";
      flake = false;
    };
    neogit = {
      url = "github:NeogitOrg/neogit/nightly";
      flake = false;
    };
    tree-sitter-d2 = {
      url = "github:ravsii/tree-sitter-d2";
      flake = false;
    };
    tree-sitter-just = {
      url = "github:IndianBoy42/tree-sitter-just";
      flake = false;
    };
    d2 = {
      url = "github:terrastruct/d2-vim";
      flake = false;
    };
    navigator = {
      url = "github:ray-x/navigator.lua";
      flake = false;
    };
    guihua = {
      url = "github:ray-x/guihua.lua";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    nvim = forEachSystem (system:
      import ./nvim.nix {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = import ./overlays.nix {
            inherit inputs;
          };
        };
      });
  in rec {
    packages = forEachSystem (system: rec {
      neovim = nvim.${system}.neovim;
      default = neovim;
    });
    overlays = {
      default = prev: final: {
        sneovim = packages.${final.system}.neovim;
      };
    };
  };
}
