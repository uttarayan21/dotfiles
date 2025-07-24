{...}: {
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
    domains = ["lemur-newton.ts.net"];
    fallbackDns = ["192.168.0.125"];
  };
}
