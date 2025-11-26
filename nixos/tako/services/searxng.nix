{
  config,
  pkgs,
  ...
}: {
  systemd.services.websurfx = {
    description = "Websurfx";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.websurfx}/bin/websurfx";
      Restart = "always";
      RestartSec = 5;
      User = "websurfx";
      Group = "websurfx";
    };
  };
  users.users.websurfx = {
    group = "websurfx";
    home = "/var/lib/websurfx";
    isSystemUser = true;
    # uid = config.ids.uids.websurfx;
  };
  users.groups.websurfx = {
    # gid = config.ids.gids.websurfx;
  };
  services.caddy.virtualHosts."search.darksailor.dev".extraConfig = ''
    reverse_proxy localhost:8080
  '';
}
