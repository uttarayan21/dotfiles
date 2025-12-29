{...}: {
  # Disable all the dns stuff in favour of tailscale's DNS
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
    domains = ["lemur-newton.ts.net"];
    fallbackDns = [];
  };
  networking.nameservers = [];
}
