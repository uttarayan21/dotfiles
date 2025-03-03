{
  config,
  pkgs,
  device,
  ...
}: {
  imports = [./services];

  # environment.systemPackages = with pkgs; [nix neovim];
  nix = {
    settings = {
      experimental-features = "nix-command flakes auto-allocate-uids";
      max-jobs = 8;
      trusted-users = ["root" "servius"];
      substituters = [
        "https://nix-community.cachix.org"
        # "https://sh.darksailor.dev"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "mirai:bcVPoFGBZ0i7JAKMXIqLj2GY3CulLC4kP7rQyqes1RM="
      ];
    };
    extraOptions = ''
      build-users-group = nixbld
      extra-nix-path = nixpkgs=flake:nixpkgs
      builders-use-substitutes = true
    '';
    package = pkgs.nixVersions.latest;
    buildMachines = [
      # ../../builders/mirai.nix
      # ../../builders/shiro.nix
    ];
    distributedBuilds = true;
  };

  users.users.servius = {
    # isNormalUser = true;
    openssh.authorizedKeys.keyFiles = [../../secrets/id_ed25519.pub];
  };
  users.users.remotebuilder = {
    name = "remotebuilder";
    uid = 700;
    home = "/var/lib/remotebuilder";
    createHome = true;
    shell = "/bin/bash";
    openssh.authorizedKeys.keyFiles = [../../secrets/id_ed25519.pub];
  };

  # security.pam.enableSudoTouchIdAuth = true;
  # system.patches = [
  #   (pkgs.writeText "pam-reattach.patch"
  #     # diff
  #     ''
  #       new file mode 100644
  #       index 0000000..e4293c0
  #       --- /dev/null
  #       +++ b/etc/pam.d/sudo_local
  #       @@ -0,0 +1,3 @@
  #       +# sudo_local: local config file which survives system update and is included for sudo
  #       +# uncomment following line to enable Touch ID for sudo
  #       +auth       optional     ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
  #     '')
  # ];

  # programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # services.nix-daemon.enable = true;
  system.stateVersion = 4;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  system.keyboard.swapLeftCommandAndLeftAlt = true;
  system.keyboard.userKeyMapping = [
    {
      # Right Command to Option
      HIDKeyboardModifierMappingSrc = 30064771303;
      HIDKeyboardModifierMappingDst = 30064771302;
    }
    {
      # Right Option to command
      HIDKeyboardModifierMappingSrc = 30064771302;
      HIDKeyboardModifierMappingDst = 30064771303;
    }
  ];
}
