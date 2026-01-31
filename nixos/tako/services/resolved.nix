{...}: {
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
}
