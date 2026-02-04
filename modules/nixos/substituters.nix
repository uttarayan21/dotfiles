{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nix.substituters;
in {
  options.nix.substituters = {
    enableCuda = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NixOS CUDA cache";
    };

    enableLlamaCpp = mkOption {
      type = types.bool;
      default = false;
      description = "Enable llama-cpp cache";
    };
  };

  config = {
    nix.settings = {
      trusted-substituters =
        [
          "https://nix-community.cachix.org"
          "https://nixos-raspberrypi.cachix.org"
        ]
        ++ optionals cfg.enableLlamaCpp [
          "https://llama-cpp.cachix.org"
        ]
        ++ optionals cfg.enableCuda [
          "https://cache.nixos-cuda.org"
        ];

      trusted-public-keys =
        [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
        ]
        ++ optionals cfg.enableLlamaCpp [
          "llama-cpp.cachix.org-1:H75X+w83wUKTIPSO1KWy9ADUrzThyGs8P5tmAbkWhQc="
        ]
        ++ optionals cfg.enableCuda [
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        ];
    };
  };
}
