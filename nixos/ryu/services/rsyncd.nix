{...}: {
  services.rsyncd = {
    enable = false;
    # openFirewall = true;
    settings = {
      media = {
        path = "/media";
        comment = "Media";
        "read only" = true;
        # "use chroot" = "no";
        list = true;
        uid = "root";
        gid = "root";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [873];
  networking.firewall.allowedUDPPorts = [873];
}
