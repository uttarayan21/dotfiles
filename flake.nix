{
  description = "Home Manager configuration of fs0c131y";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-nixos-options = {
      url = "github:uttarayan21/anyrun-nixos-options/anyrun-update";
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
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    music-player = {
      url = "github:tsirysndr/music-player";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/nur";
    zjstatus = {
      url = "github:dj95/zjstatus";
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
    nno = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    d2 = {
      url = "github:terrastruct/d2-vim";
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
    tree-sitter-slint = {
      url = "github:slint-ui/tree-sitter-slint";
      flake = false;
    };
    tree-sitter-nu = {
      url = "github:nushell/tree-sitter-nu";
      flake = false;
    };
    tree-sitter-pest = {
      url = "github:pest-parser/tree-sitter-pest";
      flake = false;
    };
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    anyrun = {
      # My fork of anyrun that allows up / down with <C-n> / <C-p>
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-hyprwin = {
      url = "github:uttarayan21/anyrun-hyprwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    onepassword-shell-plugins = {
      url = "github:1Password/shell-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmux-float = {
      url = "github:uttarayan21/tmux-float";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ddcbacklight = {
      url = "github:uttarayan21/ddcbacklight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprmonitors = {
      url = "git+https://git.darksailor.dev/servius/hyprmonitors";
      # url = "path:/home/servius/Projects/hyprmonitors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    # alvr = {
    #   url = "path:/home/servius/Projects/ALVR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    handoff = {
      url = "github:xatuke/handoff";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crates-io-index = {
      url = "git+https://github.com/rust-lang/crates.io-index?shallow=1";
      flake = false;
    };
    crates-nix = {
      url = "github:uttarayan21/crates.nix";
      inputs.crates-io-index.follows = "crates-io-index";
    };
    headplane = {
      url = "github:tale/headplane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae = {
      url = "github:vicinaehq/vicinae";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    eilmeldung = {
      url = "github:christo-auer/eilmeldung";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    servius-website = {
      url = "git+https://git.darksailor.dev/servius/servius.neocities.org";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixify = {
      url = "github:uttarayan21/nixify";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tangled-core = {
      url = "git+https://tangled.org/tangled.org/core";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iamb = {
      url = "github:ulyssa/iamb/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cinny = {
      url = "github:cinnyapp/cinny/dev";
      flake = false;
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    home-manager-stable,
    nix-darwin,
    flake-utils,
    anyrun,
    nur,
    deploy-rs,
    nixos-raspberrypi,
    ...
  } @ inputs: let
    devices = {
      tako = mkDevice {
        name = "tako";
        system = "x86_64-linux";
        user = "servius";
        hasGui = false;
        isNix = true;
        isServer = true;
      };
      ryu = mkDevice {
        name = "ryu";
        system = "x86_64-linux";
        user = "servius";
        isNix = true;
        monitors = {
          # Gigabyte FO27Q3
          primary = "HDMI-A-1";
          # Acer XV272U
          secondary = "DP-3";
          # Gigabyte M27Q
          tertiary = "DP-1";
        };
      };
      tsuba = mkDevice {
        name = "tsuba";
        system = "aarch64-linux";
        user = "servius";
        hasGui = false;
        isNix = true;
        isServer = true;
      };
      kuro = mkDevice {
        name = "kuro";
        system = "aarch64-darwin";
        user = "fs0c131y";
      };
      shiro = mkDevice {
        name = "shiro";
        system = "aarch64-darwin";
        user = "servius";
        isServer = false;
      };
      deck = mkDevice {
        name = "SteamDeck";
        system = "x86_64-linux";
        user = "deck";
        hasGui = false; # Don't wan't to run GUI apps on the SteamDeck
        isServer = true;
      };
    };

    mkDevice = device: rec {
      isLinux = !isNull (builtins.match ".*-linux" device.system);
      isServer =
        if (builtins.hasAttr "isServer" device)
        then device.isServer
        else false;
      isNix =
        if (builtins.hasAttr "isNix" device)
        then device.isNix
        else false;
      isDarwin = !isNull (builtins.match ".*-darwin" device.system);
      isArm = !isNull (builtins.match "aarch64-.*" device.system);
      isDesktopLinux = isLinux && hasGui;
      hasGui =
        if (builtins.hasAttr "hasGui" device)
        then device.hasGui
        else true;
      monitors =
        if (builtins.hasAttr "monitors" device)
        then device.monitors
        else null;
      system = device.system;
      name = device.name;
      user = device.user;
      is = name: device.name == name;
      home =
        if isDarwin
        then "/Users/${device.user}"
        else "/home/${device.user}";
      uid =
        if (builtins.hasAttr "uid" device)
        then device.uid
        else 1000;
      gid =
        if (builtins.hasAttr "gid" device)
        then device.gid
        else 1000;
      # output =
      #   if isDarwin
      #   then self.darwinConfigurations."${device.name}"
      #   else self.nixosConfigurations."${device.name}";
    };

    nixos_devices = nixpkgs.lib.attrsets.filterAttrs (n: x: x.isNix) devices;
    # linux_devices = nixpkgs.lib.attrsets.filterAttrs (n: x: x.isLinux) devices;
    darwin_devices = nixpkgs.lib.attrsets.filterAttrs (n: x: x.isDarwin) devices;
    rpi_devices = nixpkgs.lib.attrsets.filterAttrs (n: x: x.isArm && x.isLinux) devices;

    overlays = import ./overlays.nix {
      inherit inputs;
    };
  in
    {
      nixosConfigurations =
        (import ./nixos {
          inherit inputs nixpkgs home-manager overlays nur;
          devices = nixos_devices;
        })
        // (
          import ./nixos/tsuba {
            inherit inputs nixpkgs home-manager-stable overlays nur nixos-raspberrypi;
            devices = rpi_devices;
          }
        );

      darwinConfigurations = let
        devices = darwin_devices;
      in
        import ./darwin {
          inherit devices inputs nixpkgs home-manager overlays nur nix-darwin;
          sops-nix = inputs.sops-nix;
        };

      homeConfigurations = {
        deck = let
          pkgs = import inputs.nixpkgs {
            inherit overlays;
            system = "x86_64-linux";
          };
        in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs;
            };
            modules = [
              {nixpkgs.config.allowUnfree = true;}
              ./steamdeck
            ];
          };
      };

      installerImages = let
        nixos = self.nixosConfigurations;
        mkImage = nixosConfig: nixosConfig.config.system.build.sdImage;
      in {
        tsuba = mkImage nixos.tsuba;
      };
      deploy = import ./deploy.nix {inherit inputs self deploy-rs;};
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
      inherit devices;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = import ./overlays.nix {
            inherit inputs;
          };
          config.allowUnfree = true;
        };
        cratesNix = inputs.crates-nix.mkLib {inherit pkgs;};
      in {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [sops just openssl ast-grep];
          };
        };
        packages = {
          default = cratesNix.buildCrate "ironclaw" {
            nativeBuildInputs = [pkgs.pkg-config];
            buildInputs = [pkgs.openssl];
            doCheck = false;
          };
        };
      }
    );
}
