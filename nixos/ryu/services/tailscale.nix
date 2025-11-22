{masterPkgs, ...}: {
  services = {
    tailscale = {
      enable = true;
      package = masterPkgs.tailscale;
    };
  };
}
