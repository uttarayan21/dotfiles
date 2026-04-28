{inputs, ...}: {
  services.caddy.virtualHosts."adarkdayinmy.life".extraConfig = ''
    root * ${inputs.shitpost-src}/
    file_server
  '';
}
