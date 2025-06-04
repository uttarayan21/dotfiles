{
  pkgs,
  lib,
  ...
}: {
  services = {
    tailscale = {
      enable = true;
      # useRoutingFeatures = "both";
      # extraUpFlags = ["--advertise-routes=192.168.0.0/24"];
    };
    # networkd-dispatcher = {
    #   enable = true;
    #   rules."50-tailscale" = {
    #     onState = ["routable"];
    #     script = ''
    #       ${lib.getExe pkgs.ethtool} -K en01 rx-udp-gro-forwarding on rg-xgro-list off
    #     '';
    #   };
    # };
  };
}
