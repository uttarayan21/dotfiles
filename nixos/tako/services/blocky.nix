{
  device,
  config,
  ...
}: {
  services = {
    blocky = {
      enable = true;
      settings = {
        ports.dns = 53;
        ports.http = 83838;
        ports.dohPath = "/dns-query";
      };
    };
    caddy.virtualHosts."blocky.${device.domain}".extraConfig = ''
      reverse_proxy localhost:83838
    '';
  };
}
