{...}: {
  # Disable all the dns stuff in favour of tailscale's DNS
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNSSEC = "true";
        DNSoverTLS = "true";
        Domains = ["lemur-newton.ts.net"];
        FallbackDNS = [];
      };
    };
  };
  networking.nameservers = [];
}
