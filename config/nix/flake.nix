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
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    home-manager,
    darwin,
    flake-utils,
    ...
  } @ inputs: let
    devices = [
      {
        name = "mirai";
        system = "x86_64-linux";
        user = "fs0c131y";
      }
      {
        name = "genzai";
        system = "x86_64-linux";
        user = "fs0c131y";
      }
      {
        name = "Uttarayans-MacBook-Pro";
        system = "aarch64-darwin";
        user = "fs0c131y";
      }
      {
        name = "SteamDeck";
        system = "x86_64-linux";
        user = "deck";
      }
    ];
    linux = builtins.filter (x: x.system == "x86_64-linux") devices;
    darwin = builtins.filter (x: x.system == "aarch64-darwin") devices;
  in {
    homeConfigurations = builtins.listToAttrs (builtins.map (device: {
        name = device.user;
        value = let
          pkgs = nixpkgs.legacyPackages.${device.system};
          overlays = [inputs.neovim-nightly-overlay.overlay];
        in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ./home.nix
              {
                nixpkgs.overlays = overlays;
              }
            ];
          };
      })
      linux);

    darwinConfigurations = builtins.listToAttrs (builtins.map (device: {
        name = device.name;
        value = let
          pkgs = nixpkgs.legacyPackages.${device.system};
        in {
          "Uttarayans-MacBook-Pro" = darwin.lib.darwinSystem {
            modules = [
              home-manager.darwinModules.home-manager
              ./darwin.nix
              ({config, ...}: {
                home-manager = {
                  users = {
                    fs0c131y = {
                      home = "/Users/${device.user}";
                      stateVersion = "21.05";
                      configuration = home-manager.configurations.fs0c131y;
                    };
                  };
                };
              })
            ];
          };
        };
      })
      darwin);
  };
}
# "fs0c131y" = let
#   system = "x86_64-linux";
#   overlays = [inputs.neovim-nightly-overlay.overlay];
#   pkgs = nixpkgs.legacyPackages.${system};
# in
#   home-manager.lib.homeManagerConfiguration
#   {
#     inherit pkgs;
#     modules = [
#       ./home.nix
#       {
#         nixpkgs.overlays = overlays;
#       }
#     ];
#   };
# darwinConfigurations = let
#   system = "aarch64-darwin";
#   pkgs = nixpkgs.legacyPackages.${system};
# in {
#   "Uttarayans-MacBook-Pro" = darwin.lib.darwinSystem {
#     modules = [
#       home-manager.darwinModules.home-manager
#       ./darwin.nix
#       ({config, ...}: {
#         home-manager = {
#           users = {
#             fs0c131y = {
#               home = "/Users/fs0c131y";
#               stateVersion = "21.05";
#               configuration = home-manager.configurations.fs0c131y;
#             };
#           };
#         };
#       })
#     ];
#   };
# };

