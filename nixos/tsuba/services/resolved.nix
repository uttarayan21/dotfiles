{...}: {
  services.resolved = {
    enable = false;
    settings = {
      FallbackDNS = [];
    };
  };
  networking.nameservers = [];
}
