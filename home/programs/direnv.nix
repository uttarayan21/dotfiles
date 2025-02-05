{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.direnv = {
    enable = true;
    # enableFishIntegration = lib.mkForce true; # Auto enabled
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };
}
