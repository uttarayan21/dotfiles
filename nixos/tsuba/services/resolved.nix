{lib, ...}: {
  services.resolved = {
    enable = false;
    # dnssec = "true";
    # domains = ["~." "lemur-newton.ts.net"];
    # fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    fallbackDns = [];
    # dnsovertls = "true";
  };
  networking.nameservers = [];
}
