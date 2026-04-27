{...}: let
  caches = [
    "https://cache.darksailor.dev"
    "https://nix-community.cachix.org"
    "https://nixos-raspberrypi.cachix.org"
    "https://llama-cpp.cachix.org"
    "https://cache.nixos-cuda.org"
  ];
in {
  config = {
    nix.settings = {
      substituters = caches;
      trusted-substituters = caches;

      trusted-public-keys = [
        "cache.darksailor.dev-1:SE3fTKFjzPJ6A5rrmZcRYlJme6/zSpRI1yVu3366u6k=" # harmonia (tako) cache signing key
        "cache.shiro-1:6LdQLhp0+TocABKct7ab9zqsUPTspiH7Y52N5qzPCvs=" # shiro cache signing key
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
        "llama-cpp.cachix.org-1:H75X+w83wUKTIPSO1KWy9ADUrzThyGs8P5tmAbkWhQc="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };
  };
}
