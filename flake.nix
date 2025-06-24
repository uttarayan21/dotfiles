{
  description = "Home Manager configuration of fs0c131y";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    openapi-tui = {
      url = "github:zaghaghi/openapi-tui";
      flake = false;
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
    nno = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pets = {
      url = "github:giusgad/pets.nvim";
      flake = false;
    };
    rest-nvim = {
      url = "github:rest-nvim/rest.nvim";
      flake = false;
    };
    neogit = {
      url = "github:NeogitOrg/neogit/nightly";
      flake = false;
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
    navigator = {
      url = "github:ray-x/navigator.lua";
      flake = false;
    };
    guihua = {
      url = "github:ray-x/guihua.lua";
      flake = false;
    };
    tmux-float = {
      url = "github:uttarayan21/tmux-float";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ddcbacklight = {
      url = "github:uttarayan21/ddcbacklight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    typr = {
      url = "github:nvzone/typr";
      flake = false;
    };
    volt = {
      url = "github:nvzone/volt";
      flake = false;
    };
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zeronsd = {
      url = "github:uttarayan21/zeronsd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # alvr = {
    #   url = "git+file:/home/servius/Projects/ALVR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixos-rpi = {
      url = "github:nvmd/nixos-raspberrypi/main";
    };
    command-runner = {
      # url = "github:uttarayan21/command-runner";
      url = "git+file:/home/servius/Projects/command-runner";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
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
    nixos-rpi,
    ...
  } @ inputs: let
    devices = {
      mirai = mkDevice {
        name = "mirai";
        system = "x86_64-linux";
        user = "fs0c131y";
        hasGui = false; # Don't wan't to run GUI apps on a headless server
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
      deoxys = mkDevice {
        name = "deoxys";
        system = "x86_64-linux";
        user = "servius";
        hasGui = false; # It's a vm so no GUI apps are used
        isNix = true;
        isServer = true;
      };
      ude = mkDevice {
        name = "ude";
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

    mkDevice = device: {
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
    };

    nixos_devices = nixpkgs.lib.attrsets.filterAttrs (n: x: x.isNix) devices;
    linux_devices = nixpkgs.lib.attrsets.filterAttrs (n: x: x.isLinux) devices;
    darwin_devices = nixpkgs.lib.attrsets.filterAttrs (n: x: x.isDarwin) devices;
    rpi_devices = nixpkgs.lib.attrsets.filterAttrs (n: x: x.isArm && x.isLinux) devices;

    overlays = import ./overlays.nix {
      inherit inputs;
    };
  in
    rec {
      nixosConfigurations =
        (import ./nixos {
          inherit inputs nixpkgs home-manager overlays nur;
          devices = nixos_devices;
        })
        // (
          import ./nixos/ude {
            inherit inputs nixpkgs home-manager overlays nur nixos-rpi;
            devices = rpi_devices;
          }
        );

      darwinConfigurations = let
        devices = darwin_devices;
      in
        import ./darwin {
          inherit devices inputs nixpkgs home-manager overlays nur nix-darwin;
        };

      homeConfigurations = let
        devices = linux_devices;
      in
        (import ./home/linux/device.nix {
          inherit devices inputs nixpkgs home-manager overlays;
        })
        // {
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

      deploy = import ./deploy.nix {inherit inputs self;};
      inherit devices;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = import ./overlays.nix {
            inherit inputs;
          };
        };
      in {
        packages = rec {
          default = neovim;
          neovim = pkgs.nixvim.makeNixvim (import ./neovim);
        };
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [sops just];
          };
        };
      }
    );
}
