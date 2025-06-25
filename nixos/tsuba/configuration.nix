{
  config,
  pkgs,
  lib,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = true;
      extra-experimental-features = "nix-command flakes auto-allocate-uids";
      trusted-users = ["root" "fs0c131y" "remotebuilder"];
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
      secret-key-files = ${config.sops.secrets."builder/mirai/cache/private".path}
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
  users.users.servius = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [
      ../../secrets/id_ed25519.pub
      ../../secrets/id_ios.pub
    ];
  };
}
