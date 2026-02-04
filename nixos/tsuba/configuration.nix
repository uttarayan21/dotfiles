{
  config,
  pkgs,
  lib,
  device,
  ...
}: {
  imports = [
    ../../modules/nixos/substituters.nix
  ];

  users.extraUsers.servius.extraGroups = ["docker"];
  networking.firewall.enable = false;
  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;
  security.sudo.wheelNeedsPassword = false;
  nix = {
    settings = {
      auto-optimise-store = true;
      extra-experimental-features = "nix-command flakes auto-allocate-uids";
      trusted-users = ["root" "remotebuilder" device.user];
    };
    extraOptions = ''
      build-users-group = nixbld
      extra-nix-path = nixpkgs=flake:nixpkgs
      builders-use-substitutes = true
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 5d";
    };
    package = pkgs.nixVersions.latest;
    distributedBuilds = true;
    buildMachines = [
      ../../builders/tako.nix
      ../../builders/shiro.nix
    ];
  };
  users.users.${device.user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "media"];
    initialPassword = "aaa";
    openssh.authorizedKeys.keyFiles = [
      ../../secrets/id_ed25519.pub
      ../../secrets/id_ios.pub
    ];
  };
  users.users.remotebuilder = {
    isNormalUser = true;
    openssh.authorizedKeys.keyFiles = [
      ../../secrets/id_ed25519.pub
    ];
  };
  users.groups.media = {};
  system.stateVersion = "25.05";
  time.timeZone = "Asia/Kolkata";
}
