{...}: {
  services.caddy = {
    virtualHosts."books.darksailor.dev".extraConfig = ''
      import auth
      reverse_proxy ryu:${toString 8293}
    '';
  };
}
