{...}: {
  imports = [
    ../../../../modules/nixos/satisfactory.nix
  ];
  services.satisfactory = {
    # enable = true;
    enable = false;
    maxPlayers = 4;
  };
}
