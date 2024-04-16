{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nnn = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    norg.url = "github:nvim-neorg/tree-sitter-norg/dev";
    norg-meta.url = "github:nvim-neorg/tree-sitter-norg-meta";

    neorg = {
      url = "github:nvim-neorg/neorg";
      flake = false;
    };
    neorg-telescope = {
      url = "github:nvim-neorg/neorg-telescope";
      flake = false;
    };

    nvim-devdocs.url = "github:luckasRanarison/nvim-devdocs";
    nvim-devdocs.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    nixvim,
    nnn,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    nvim = forEachSystem (system:
      import ./nvim.nix {
        pkgs = import nixpkgs {
          inherit system;
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
