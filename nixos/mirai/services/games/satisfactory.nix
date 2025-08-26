{...}: {
  imports = [
    ../../../../modules/nixos/satisfactory.nix
  ];
  services.satisfactory = {
    enable = true;
    maxPlayers = 4;
  };
}
