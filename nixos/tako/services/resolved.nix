{...}: {
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
    domains = ["lemur-newton.ts.net"];
    fallbackDns = ["1.1.1.1"];
  };
}
