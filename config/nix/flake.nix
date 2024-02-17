{
  description = "Home Manager configuration of fs0c131y";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    # nixos,
    home-manager,
    nix-darwin,
    flake-utils,
    anyrun,
    neovim-nightly-overlay,
    ...
  } @ inputs: let
    config_devices = [
      {
        name = "mirai";
        system = "x86_64-linux";
        user = "fs0c131y";
      }
      {
        name = "ryu";
        system = "x86_64-linux";
        user = "servius";
        isNix = true;
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

    mkDevice = {device, ...}: {
      isLinux = !isNull (builtins.match ".*-linux" device.system);
      isNix =
        if (builtins.hasAttr "isNix" device)
        then device.isNix
        else false;
      isMac = !isNull (builtins.match ".*-darwin" device.system);
      system = device.system;
      name = device.name;
      user = device.user;
    };

    devices = builtins.map (device: mkDevice {inherit device;}) config_devices;

    nixos_devices = builtins.filter (x: x.isNix) devices;
    linux_devices = builtins.filter (x: x.isLinux) devices;
    darwin_devices = builtins.filter (x: x.isMac) devices;

    anyrun-overlay = final: prev: {
      anyrun = inputs.anyrun.packages.${prev.system}.anyrun;
    };
    overlays = [
      inputs.neovim-nightly-overlay.overlay
      anyrun-overlay
      # inputs.anyrun.overlays
    ];
  in {
    nixosConfigurations =
      builtins.listToAttrs
      (builtins.map
        (device: {
          name = device.name;
          value = nixpkgs.lib.nixosSystem {
            system = device.system;
            # system.packages = [anyrun.packages.${device.system}.anyrun];
            specialArgs = {inherit device;};
            modules = [
              {nixpkgs.overlays = overlays;}
              ./nixos/configuration.nix
              home-manager.nixosModules.home-manager
              {
                nixpkgs.config.allowUnfree = true;
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs;
                    inherit device;
                  };
                  users.${device.user}.imports = [./common/home.nix];
                };
              }
            ];
          };
        })
        nixos_devices);

    homeConfigurations = builtins.listToAttrs (builtins.map
      (device: {
        name = device.user;
        value = let
          pkgs = nixpkgs.legacyPackages.${device.system};
        in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit device;
            };
            modules = [
              {nixpkgs.overlays = overlays;}
              ./common/home.nix
              {
                nixpkgs.overlays = overlays;
              }
            ];
          };
      })
      linux_devices);

    darwinConfigurations =
      builtins.listToAttrs
      (builtins.map
        (device: {
          name = device.name;
          value = let
            pkgs = nixpkgs.legacyPackages.${device.system};
          in
            nix-darwin.lib.darwinSystem {
              inherit pkgs;
              modules = [
                {nixpkgs.overlays = overlays;}
                ./darwin
                home-manager.darwinModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = {
                      inherit device;
                    };
                    users.${device.user}.imports = [./common/home.nix];
                  };
                }
              ];
            };
        })
        darwin_devices);
  };
}
