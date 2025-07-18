{
  config,
  pkgs,
  lib,
  device,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  security.sudo.wheelNeedsPassword = false;
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/servius/.config/sops/age/keys.txt";
  };
  nix = {
    settings = {
      auto-optimise-store = true;
      extra-experimental-features = "nix-command flakes auto-allocate-uids";
      trusted-users = ["root" "remotebuilder" device.user];
      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://nixos-raspberrypi.cachix.org"
      ];
      trusted-public-keys = [
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
      options = "--delete-older-than 5d";
    };
    package = pkgs.nixVersions.latest;
    distributedBuilds = true;
    buildMachines = [
      ../../builders/mirai.nix
      ../../builders/shiro.nix
      ../../builders/tsuba.nix
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
  services.openssh.enable = true;
}
