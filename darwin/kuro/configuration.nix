{
  config,
  pkgs,
  device,
  ...
}: {
  imports = [./services ./homebrew.nix ./programs];

  # environment.systemPackages = with pkgs; [nix neovim];
  nix = {
    enable = true;
    settings = {
      # ids.gids.nixbld = 30000;
      experimental-features = "nix-command flakes auto-allocate-uids";
      max-jobs = 8;
      trusted-users = ["root" device.user];
      substituters = [
        "https://cache.darksailor.dev"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.darksailor.dev-1:SE3fTKFjzPJ6A5rrmZcRYlJme6/zSpRI1yVu3366u6k=" # harmonia (tako) cache signing key
        "cache.shiro-1:6LdQLhp0+TocABKct7ab9zqsUPTspiH7Y52N5qzPCvs=" # shiro cache signing key
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      download-buffer-size = 524288000;
    };
    extraOptions = ''
      build-users-group = nixbld
      extra-nix-path = nixpkgs=flake:nixpkgs
      builders-use-substitutes = true
    '';
    package = pkgs.nixVersions.latest;
    buildMachines = [
      ../../builders/tako.nix
      ../../builders/shiro.nix
    ];
    distributedBuilds = true;
  };

  # security.pam.enableSudoTouchIdAuth = true;
  security.pam.services.sudo_local.touchIdAuth = true;
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
  system.stateVersion = 5;
  system.primaryUser = device.user;

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
