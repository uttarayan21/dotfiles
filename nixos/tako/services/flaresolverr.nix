{stablePkgs, ...}: {
  services = {
    flaresolverr = {
      enable = true;
      package = stablePkgs.flaresolverr;
    };
  };
}
