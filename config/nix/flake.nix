{
  description = "Home Manager configuration of fs0c131y";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    nixpkgs,
    home-manager,
    darwin,
    ...
  } @ inputs: {
    homeConfigurations = let
      system = "x86_64-linux";
      overlays = [inputs.neovim-nightly-overlay.overlay];
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      "fs0c131y" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
          {
            nixpkgs.overlays = overlays;
          }
        ];
      };
    };

    darwinConfigurations = let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      "Uttarayans-MacBook-Pro" = darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          ./darwin.nix
          ({config, ...}: {
            home-manager = {
              users = {
                fs0c131y = {
                  home = "/Users/fs0c131y";
                  stateVersion = "21.05";
                  configuration = home-manager.configurations.fs0c131y;
                };
              };
            };
          })
        ];
      };
    };
  };
}
