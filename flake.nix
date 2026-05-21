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
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
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
    hdbctrl = {
      url = "path:/home/servius/Projects/hdb630";
      # url = "git+https://git.darksailor.dev/servius/hdbctrl";
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
    slo.url = "git+https://git.darksailor.dev/servius/slo";
    nixify = {
      url = "github:uttarayan21/nixify";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tangled-core = {
      url = "git+https://tangled.org/tangled.org/core";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.55.2";
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
    lichtfeld = {
      url = "github:uttarayan21/lichtfeld-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # kobors = {
    #   url = "git+ssh://gitea@git.darksailor.dev/servius/kobors";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixos-dns = {
      url = "github:Janik-Haag/nixos-dns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pinned source inputs (replace fetchFromGitHub/fetchgit). Update with `nix flake update <name>`.
    bblauncher-src = {
      url = "git+https://github.com/rainmakerv3/BB_Launcher?ref=refs/tags/Release15.01&submodules=1";
      flake = false;
    };
    shadps4-src = {
      url = "git+https://github.com/shadps4-emu/shadPS4?ref=refs/tags/v.0.15.0&submodules=1";
      flake = false;
    };
    shadps4-prerelease-src = {
      # Original tag: Pre-release-shadPS4-2026-04-25-a762f70 (auto-deleted upstream — pin commit SHA)
      url = "git+https://github.com/shadps4-emu/shadPS4?ref=main&rev=a762f70df3fc23185540f88724b261b065e5d979&submodules=1";
      flake = false;
    };
    shadps4-diegolix29-src = {
      url = "git+https://github.com/diegolix29/shadPS4?ref=main&rev=6e87e74924cf61b55bef8c96d09513cb3ae23625&submodules=1";
      flake = false;
    };
    shadps4-qtlauncher-src = {
      url = "git+https://github.com/shadps4-emu/shadps4-qtlauncher?ref=main&rev=c39f5977f667e4fea126a2d6d2ab5cb68efcda6a&submodules=1";
      flake = false;
    };
    ollama-src = {
      url = "github:ollama/ollama/v0.24.0";
      flake = false;
    };
    tmux-super-fingers-src = {
      url = "github:artemave/tmux_super_fingers/518044ef78efa1cf3c64f2e693fef569ae570ddd";
      flake = false;
    };
    libfprint-cs9711-src = {
      url = "github:archeYR/libfprint-CS9711/c2d163fbb06d33e80a5177815bb0b8ca2f01739f";
      flake = false;
    };
    catppuccin-bat = {
      url = "github:catppuccin/bat/b19bea35a85a32294ac4732cad5b0dc6495bed32";
      flake = false;
    };
    catppuccin-hyprland = {
      url = "github:catppuccin/hyprland/fc228737d3d0c12e34a7fa155a0fc3192e5e4017";
      flake = false;
    };
    catppuccin-starship = {
      url = "github:catppuccin/starship/5629d2356f62a9f2f8efad3ff37476c19969bd4f";
      flake = false;
    };
    catppuccin-fish = {
      url = "github:catppuccin/fish/0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
      flake = false;
    };
    catppuccin-waybar = {
      url = "github:catppuccin/waybar/v1.1";
      flake = false;
    };
    catppuccin-newsboat = {
      url = "github:catppuccin/newsboat/be3d0ee1ba0fc26baf7a47c2aa7032b7541deb0f";
      flake = false;
    };
    catppuccin-yazi = {
      url = "github:catppuccin/yazi/043ffae14e7f7fcc136636d5f2c617b5bc2f5e31";
      flake = false;
    };
    shitpost-src = {
      url = "git+https://git.darksailor.dev/servius/adarkdayinmylife.public?rev=68d972f68cab8f68916b94df05b7ab6a7da4a1da";
      flake = false;
    };
    # nix-proton-cachyos = {
    #   url = "github:uttarayan21/nix-proton-cachyos";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
    system-manager,
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
        tailscaleIp = "100.102.64.19";
        externalIp = "15.235.165.172";
      };
      ryu = mkDevice {
        name = "ryu";
        system = "x86_64-linux";
        user = "servius";
        isNix = true;
        tailscaleIp = "100.78.171.80";
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
        tailscaleIp = "100.87.221.59";
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
        tailscaleIp = "100.80.149.119";
      };
      yuge = mkDevice {
        name = "yuge";
        system = "x86_64-linux";
        user = "deck";
        hasGui = false;
        isServer = true;
        isSystemManager = true;
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
      isSystemManager =
        if (builtins.hasAttr "isSystemManager" device)
        then device.isSystemManager
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
      tailscaleIp =
        if (builtins.hasAttr "tailscaleIp" device)
        then device.tailscaleIp
        else null;
      externalIp =
        if (builtins.hasAttr "externalIp" device)
        then device.externalIp
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
    systemManager_devices = nixpkgs.lib.attrsets.filterAttrs (n: x: x.isSystemManager) devices;

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

      systemConfigs = import ./system-manager {
        inherit inputs system-manager;
        devices = systemManager_devices;
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
