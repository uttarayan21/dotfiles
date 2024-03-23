# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  device,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./ryu.nix
  ];

  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.mullvad-vpn.enable = true;
  services.resolved.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than +5";

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.plymouth.enable = true;
  boot.plymouth.theme = "catppuccin-mocha";
  boot.plymouth.themePackages = with pkgs; [(catppuccin-plymouth.override {variant = "mocha";})];

  services.greetd = let
    tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
    hyprland-session = "${pkgs.hyprland}/share/wayland-sessions";
  in {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --remember-session --sessions ${hyprland-session}";
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

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

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Name = "Ryu";
      Enable = "Source,Sink,Media,Socket";
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = pkgs.lib.mkForce false;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.bootspec.enable = true;

  networking.hostName = "ryu"; # Define your hostname.
  networking.nameservers = ["1.1.1.1" "8.8.8.8"];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.udev.packages = [pkgs.yubikey-personalization pkgs.yubikey-personalization-gui];
  services.yubikey-agent.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  i18n.supportedLocales = ["en_US.UTF-8/UTF-8"];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.servius = {
    isNormalUser = true;
    description = "Uttarayan";
    extraGroups = ["networkmanager" "wheel"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;
  fonts.fontDir.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    hyprland
    xorg.xhost
    foot
    git
    fish
    nushellFull
    (pkgs.wrapFirefox
      (pkgs.firefox-unwrapped.override {pipewireSupport = true;})
      {})
    gnumake
    python3
    (nerdfonts.override {fonts = ["FiraCode" "Hasklig"];})
  ];
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  nix.settings.extra-experimental-features = "nix-command flakes";
  nix.settings.trusted-users = ["root" "servius"];
}
