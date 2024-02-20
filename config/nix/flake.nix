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
    neovim-nightly-overlay = {
      url =
        "github:nix-community/neovim-nightly-overlay/1afaeebc41dab1029b855b17d78f2348e8dd49e3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:uttarayan21/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-hyprwin = {
      url = "github:uttarayan21/anyrun-hyprwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-nixos-options = {
      url = "github:n3oney/anyrun-nixos-options";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun-rink = {
      url = "github:uttarayan21/anyrun-rink";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs,
    # nixos,
    home-manager, nix-darwin, flake-utils, anyrun, neovim-nightly-overlay, ...
    }@inputs:
    let
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

      mkDevice = { device }: {
        isLinux = !isNull (builtins.match ".*-linux" device.system);
        isNix =
          if (builtins.hasAttr "isNix" device) then device.isNix else false;
        isMac = !isNull (builtins.match ".*-darwin" device.system);
        system = device.system;
        name = device.name;
        user = device.user;
      };

      devices =
        builtins.map (device: mkDevice { inherit device; }) config_devices;

      nixos_devices = builtins.filter (x: x.isNix) devices;
      linux_devices = builtins.filter (x: x.isLinux) devices;
      darwin_devices = builtins.filter (x: x.isMac) devices;

      anyrun-overlay = final: prev: {
        anyrun = inputs.anyrun.packages.${prev.system}.anyrun;
        hyprwin = inputs.anyrun-hyprwin.packages.${prev.system}.hyprwin;
        nixos-options =
          inputs.anyrun-nixos-options.packages.${prev.system}.default;
        anyrun-rink = inputs.anyrun-rink.packages.${prev.system}.default;
      };
      overlays = [ inputs.neovim-nightly-overlay.overlay anyrun-overlay ];
      # overlays = [ anyrun-overlay ];
    in {
      nixosConfigurations = let devices = nixos_devices;
      in import ./nixos/device.nix {
        inherit devices inputs nixpkgs home-manager overlays;
      };

      darwinConfigurations = let devices = darwin_devices;
      in import ./darwin/device.nix {
        inherit devices inputs nixpkgs home-manager overlays nix-darwin;
      };

      homeConfigurations = let devices = linux_devices;
      in import ./linux/device.nix {
        inherit devices inputs nixpkgs home-manager overlays;
      };
    };
}
