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
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      # My fork of anyrun that allows up / down with <C-n> / <C-p>
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
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixneovim = {
      # url = "github:nixneovim/nixneovim";
      url = "github:uttarayan21/NixNeovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixneovimplugins = {
    #   url = "github:NixNeovim/NixNeovimPlugins";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # }
    nix-index-database.url = "github:Mic92/nix-index-database";

    nur.url = "github:nix-community/nur";

  };

  outputs =
    { nixpkgs
    , home-manager
    , nix-darwin
    , flake-utils
    , anyrun
    , nur
    , neovim-nightly-overlay
    , ...
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

      overlays = import ./overlays.nix {
        inherit inputs;
      };
    in
    {
      nixosConfigurations =
        let devices = nixos_devices;
        in import ./nixos/device.nix {
          inherit devices inputs nixpkgs home-manager overlays nur;
        };

      darwinConfigurations =
        let devices = darwin_devices;
        in import ./darwin/device.nix {
          inherit devices inputs nixpkgs home-manager overlays nix-darwin;
        };

      homeConfigurations =
        let devices = linux_devices;
        in import ./linux/device.nix {
          inherit devices inputs nixpkgs home-manager overlays;
        };
    };
}
