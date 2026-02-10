{config, ...}: {
  services.matrix-tuwunel = {
    enable = true;
    settings.global = {
      server_name = "darksailor.dev";
      unix_socket_path = "/var/run/tuwunel/tuwunel.sock";
    };
  };
  services.caddy.virtualHosts."matrix.darksailor.dev".extraConfig = ''
    reverse_proxy unix//var/run/tuwunel/tuwunel.sock
  '';
  users.users.caddy.extraGroups = ["tuwunel"];
}
