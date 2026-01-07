{stablePkgs, ...}: {
  services.tailscale = {
    enable = true;
    # package = stablePkgs.tailscale;
  };
}
