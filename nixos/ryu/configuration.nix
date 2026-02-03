{
  pkgs,
  lib,
  device,
  ...
}: {
  imports = [
    ./ryu.nix
    ./services
    ./programs
    ./containers
    ./apps
    ./vms
    ./games
  ];

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    uwsm.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  # systemd.tmpfiles.rules = [
  #   "L+ /etc/gdm/.config/monitors.xml - - - - ${./monitors.xml}"
  # ];
  security = {
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
    rtkit.enable = true;
  };

  nix = {
    settings = {
      max-jobs = 1;
      cores = 24;
      auto-optimise-store = true;
      extra-experimental-features = "nix-command flakes auto-allocate-uids";
      trusted-users = [device.user];
      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://nixos-raspberrypi.cachix.org"
        "https://llama-cpp.cachix.org"
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "llama-cpp.cachix.org-1:H75X+w83wUKTIPSO1KWy9ADUrzThyGs8P5tmAbkWhQc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
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
    package = pkgs.nixVersions.nix_2_32; # deploy-rs doesn't work with nix >= 2.33
    buildMachines = [
      ../../builders/tako.nix
      ../../builders/shiro.nix
      # ../../builders/tsuba.nix
    ];
    distributedBuilds = true;
  };

  users.users.${device.user} = {
    uid = device.uid;
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "i2c" "media" "video" "tss" "plugdev"];
    openssh.authorizedKeys.keyFiles = [
      ../../secrets/id_ed25519.pub
      ../../secrets/id_ios.pub
    ];
  };
  users.groups.i2c = {};
  users.groups.media = {};
  users.groups.${device.user} = {
    gid = device.gid;
    members = [device.user];
  };

  services = {
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
    };
    displayManager.gdm.enable = true;
    # desktopManager.gnome.enable = true;
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

  environment.etc."xdg/monitors.xml".source = ./monitors.xml;
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
    # openrazer.enable = true;
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

  networking = {
    interfaces.eno1.wakeOnLan = {
      policy = ["magic"];
      enable = true;
    };
    hostName = "ryu"; # Define your hostname.
    # nameservers = ["1.1.1.1" "8.8.8.8"];
    # nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # useDHCP = true;

    hostId = "1349f9f0";
    # Enable networking
    networkmanager.enable = true;
    nftables = {
      # Open ports in the firewall.
      # firewall.allowedTCPPorts = [ ... ];
      # firewall.allowedUDPPorts = [ ... ];
      # firewall.enable = false;
      enable = true;
      flushRuleset = true;
      tables = {
        "mullvad_tailscale" = {
          enable = true;
          family = "inet";
          content = ''
            chain output {
              type route hook output priority 0; policy accept;
              ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            }
          '';
        };
      };
      # ruleset = ''
      #   table inet mullvad_tailscale {
      #     chain output {
      #       type route hook output priority 0; policy accept;
      #       ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      #     }
      #   }
      #
      # '';
    };
    firewall = {
      enable = true;
      trustedInterfaces = [
        "tailscale0"
      ];
      allowedUDPPorts = [
        9 # Wake on LAN
        4950 # Warframe
        4955 # Warframe
      ];
      allowedTCPPorts = [
        3113 # Hyprmonitors
        11345 # lmstudio
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
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
      LC_ALL = "en_US.UTF-8";
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
      v4l-utils
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
      # (nixvim.makeNixvim (import ../../neovim))
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
    # gnome.excludePackages = with pkgs; [
    #   atomix # puzzle game
    #   cheese # webcam tool
    #   epiphany # web browser
    #   evince # document viewer
    #   geary # email reader
    #   gedit # text editor
    #   gnome-characters
    #   gnome-music
    #   gnome-photos
    #   gnome-terminal
    #   gnome-tour
    #   hitori # sudoku game
    #   iagno # go game
    #   tali # poker game
    #   totem # video player
    # ];
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
