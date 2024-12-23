{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./ryu.nix
  ];

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
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
      substituters = ["https://sh.darksailor.dev"];
      trusted-public-keys = ["mirai:bcVPoFGBZ0i7JAKMXIqLj2GY3CulLC4kP7rQyqes1RM="];
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
      {
        hostName = "sh.darksailor.dev";
        sshUser = "fs0c131y";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
    ];
    distributedBuilds = true;
  };

  services = {
    tailscale = {
      enable = true;
    };
    mullvad-vpn.enable = true;
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
    gnome.gnome-keyring.enable = true;

    # greetd = let
    #   tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
    #   hyprland-session = "${pkgs.hyprland}/share/wayland-sessions";
    # in {
    #   enable = true;
    #   settings = {
    #     default_session = {
    #       command = "${tuigreet} --time --remember --remember-session --sessions ${hyprland-session}";
    #       user = "greeter";
    #     };
    #   };
    # };
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    udev.packages = [pkgs.yubikey-personalization pkgs.yubikey-personalization-gui pkgs.via];
    yubikey-agent.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    xserver.displayManager.gdm.enable = true;
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
      pkiBundle = "/etc/secureboot";
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
  hardware = {
    keyboard.qmk.enable = true;
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

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    bluetooth.settings = {
      General = {
        Name = "Ryu";
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  services.openssh.enable = true;

  networking = {
    hostName = "ryu"; # Define your hostname.
    # nameservers = ["1.1.1.1" "8.8.8.8"];
    nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
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
  users.users.servius = {
    isNormalUser = true;
    description = "Uttarayan";
    extraGroups = ["networkmanager" "wheel" "audio"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;
  fonts.fontDir.enable = true;
  environment = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [
      #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #  wget
      hyprland
      xorg.xhost
      foot
      git
      fish
      nushell
      (pkgs.wrapFirefox
        (pkgs.firefox-unwrapped.override {pipewireSupport = true;})
        {})
      gnumake
      python3
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      nerd-fonts.symbols-only
      monaspace
    ];
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
    # etc
  };

  musnix.enable = true;
  programs = {
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
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
