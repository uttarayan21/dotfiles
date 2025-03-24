{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./ryu.nix
    ./services
    # ./vms
  ];

  programs = {
    localsend = {
      enable = true;
      openFirewall = true;
    };
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["servius"];
    };
    adb.enable = true;
    alvr.enable = true;
    alvr.openFirewall = true;
    hyprland.enable = true;
    hyprland.xwayland.enable = true;
    yubikey-touch-detector.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libglvnd
      ];
    };
    gnome-disks.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${./monitors.xml}"
  ];
  security = {
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
    # pam.services.greetd.enableGnomeKeyring = true;
    rtkit.enable = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      extra-experimental-features = "nix-command flakes auto-allocate-uids";
      trusted-users = ["root" "servius"];
      substituters = [
        # "https://nix-community.cachix.org"
        # "https://sh.darksailor.dev"
      ];
      trusted-public-keys = [
        # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "mirai:bcVPoFGBZ0i7JAKMXIqLj2GY3CulLC4kP7rQyqes1RM="
      ];
    };
    extraOptions = ''
      build-users-group = nixbld
      extra-nix-path = nixpkgs=flake:nixpkgs
      builders-use-substitutes = true
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than +5";
    };
    package = pkgs.nixVersions.latest;
    buildMachines = [
      ../../builders/mirai.nix
      ../../builders/shiro.nix
    ];
    distributedBuilds = true;
  };

  users.users.servius = {
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "i2c" "media" "openrazer"];
    openssh.authorizedKeys.keyFiles = [
      ../../secrets/id_ed25519.pub
      ../../secrets/id_ios.pub
    ];
  };
  users.groups.i2c = {};
  users.groups.media = {};

  services = {
    resolved = {
      enable = true;
      dnssec = "true";
      domains = ["~."];
      fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
      dnsovertls = "true";
    };
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gnome-settings-daemon.enable = true;
    };
    xserver = {
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = with pkgs; [(catppuccin-plymouth.override {variant = "mocha";})];
    };

    # Bootloader.
    loader.systemd-boot.enable = pkgs.lib.mkForce false;

    loader.efi.canTouchEfiVariables = true;
    bootspec.enable = true;
  };

  # systemd.services.greetd.serviceConfig = {
  #   Type = "idle";
  #   StandardInput = "tty";
  #   StandardOutput = "tty";
  #   StandardError = "journal"; # Without this errors will spam on screen
  #   # Without these bootlogs will spam on screen
  #   TTYReset = true;
  #   TTYVHangup = true;
  #   TTYVTDisallocate = true;
  # };
  # services.wireplumber.configPackages = with pkgs; [ bluez ];

  # environment.etc = {
  #   "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
  #     bluez_monitor.properties = {
  #         ["bluez5.enable-sbc-xq"] = true,
  #         ["bluez5.enable-msbc"] = true,
  #         ["bluez5.enable-hw-volume"] = true,
  #         ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
  #     }
  #   '';
  # };
  hardware = {
    keyboard.qmk.enable = true;
    openrazer.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Name = "Ryu";
          Enable = "Source,Sink,Media,Socket";
          ControllerMode = "dual";
          FactConnectable = "true";
          Experimental = "true";
        };
      };
    };
  };

  services.openssh.enable = true;

  networking = {
    interfaces.eno1.wakeOnLan = {
      policy = ["magic"];
      enable = true;
    };
    hostName = "ryu"; # Define your hostname.
    # nameservers = ["1.1.1.1" "8.8.8.8"];
    nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # useDHCP = true;

    hostId = "1349f9f0";
    # Enable networking
    networkmanager.enable = true;

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # firewall.enable = false;
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  i18n = {
    supportedLocales = ["en_US.UTF-8/UTF-8"];

    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  fonts.fontconfig.enable = true;
  fonts.fontDir.enable = true;
  environment = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [
      polychromatic
      openrazer-daemon
      cudatoolkit
      # Wine
      wine-wayland
      winetricks
      wineWowPackages.waylandFull

      virt-manager
      gparted
      nvtopPackages.nvidia
      quickemu
      (nixvim.makeNixvim (import ../../neovim))
      qpwgraph
      hyprland
      xorg.xhost
      foot
      git
      fish
      nushell
      # (pkgs.wrapFirefox
      #   (pkgs.firefox-unwrapped.override {pipewireSupport = true;})
      #   {})
      gnumake
      python3
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      nerd-fonts.symbols-only
      monaspace
      ddcutil
    ];
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
    # etc
    gnome.excludePackages = with pkgs; [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gedit # text editor
      gnome-characters
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
      totem # video player
    ];
  };

  musnix.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
