{
  description = "Home Manager configuration of fs0c131y";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    music-player = {
      url = "github:tsirysndr/music-player";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/nur";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "path:./neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    openapi-tui = {
      url = "github:zaghaghi/openapi-tui";
      flake = false;
    };
    cachix-deploy-flake = {
      url = "github:cachix/cachix-deploy-flake";
      inputs.home-manager.follows = "home-manager";
    };
    onepassword-shell-plugins = {
      url = "github:uttarayan21/shell-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    csshacks = {
      url = "github:MrOtherGuy/firefox-csshacks";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    flake-utils,
    anyrun,
    nur,
    deploy-rs,
    ...
  } @ inputs: let
    config_devices = [
      {
        name = "mirai";
        system = "x86_64-linux";
        user = "fs0c131y";
        hasGui = false; # Don't wan't to run GUI apps on a headless server
        isNix = true;
        isServer = true;
      }
      {
        name = "ryu";
        system = "x86_64-linux";
        user = "servius";
        isNix = true;
        monitors = {
          #  Gigabyte fo27q3
          primary = "HDMI-A-3";
          # Acer XV272U
          secondary = "DP-2";
          # Gigabyte M27Q
          tertiary = "DP-1";
        };
      }
      {
        name = "deoxys";
        system = "x86_64-linux";
        user = "servius";
        hasGui = false; # It's a vm so no GUI apps are used
        isNix = true;
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
        hasGui = false; # Don't wan't to run GUI apps on the SteamDeck
      }
    ];

    mkDevice = {device}: {
      isLinux = !isNull (builtins.match ".*-linux" device.system);
      isServer =
        if (builtins.hasAttr "isServer" device)
        then device.isServer
        else false;
      isNix =
        if (builtins.hasAttr "isNix" device)
        then device.isNix
        else false;
      isMac = !isNull (builtins.match ".*-darwin" device.system);
      hasGui =
        if (builtins.hasAttr "hasGui" device)
        then device.hasGui
        else true;
      monitors =
        if (builtins.hasAttr "monitors" device)
        then device.monitors
        else null;
      live =
        if (builtins.hasAttr "live" device)
        then device.live
        else false;
      system = device.system;
      name = device.name;
      user = device.user;
    };

    devices =
      builtins.map (device: mkDevice {inherit device;}) config_devices;

    nixos_devices = builtins.filter (x: x.isNix) devices;
    linux_devices = builtins.filter (x: x.isLinux) devices;
    darwin_devices = builtins.filter (x: x.isMac) devices;

    overlays = import ./overlays.nix {
      inherit inputs;
    };
  in rec {
    nixosConfigurations = let
      devices = nixos_devices;
    in
      import ./nixos/device.nix {
        inherit devices inputs nixpkgs home-manager overlays nur;
      };

    darwinConfigurations = let
      devices = darwin_devices;
    in
      import ./darwin/device.nix {
        inherit devices inputs nixpkgs home-manager overlays nix-darwin;
      };

    homeConfigurations = let
      devices = linux_devices;
    in
      import ./linux/device.nix {
        inherit devices inputs nixpkgs home-manager overlays;
      };

    packages = inputs.neovim.packages;
    deploy = {
      nodes = {
        mirai = {
          hostname = "mirai";
          profiles.system = {
            sshUser = "fs0c131y";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.mirai;
            user = "root";
          };
        };
        ryu = {
          hostname = "ryu";
          profiles.system = {
            sshUser = "servius";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ryu;
            user = "root";
          };
        };
        mbpro = {
          hostname = "Uttarayans-MacBook-Pro.local";
          profiles.system = {
            sshUser = "fs0c131y";
            path = inputs.deploy-rs.lib.aarch64-darwin.activate.darwin self.darwinConfigurations.Uttarayans-MacBook-Pro;
          };
        };
        deoxys = {
          hostname = "deoxys";
          profiles.system = {
            sshUser = "servius";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.deoxys;
            user = "root";
          };
        };
      };
    };

    devshells.default = {
      packages = packages;
    };
  };
}
