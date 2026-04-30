{
  config,
  lib,
  device,
  ...
}: {
  networking.domains.subDomains = {
    "ldap.darksailor.dev" = {};
    "lldap.darksailor.dev".a.data = device.tailscaleIp;
  };

  services.lldap = {
    enable = true;
    settings = {
      force_ldap_user_pass_reset = "always";
      ldap_user_dn = "admin";
      ldap_base_dn = "dc=darksailor,dc=dev";
      ldap_user_email = "admin@darksailor.dev";
      http_host = "127.0.0.1";
      http_port = 5090;
      ldap_port = 389;
      ldap_host = "::";
      ldap_user_pass_file = config.sops.secrets."lldap/admin".path;
      jwt_secret_file = "${config.sops.secrets."lldap/jwt".path}";
    };
    environment = {
      LLDAP_JWT_SECRET_FILE = "${config.sops.secrets."lldap/jwt".path}";
    };
  };
  services.caddy.virtualHosts."lldap.darksailor.dev".extraConfig = ''
    @tailscale remote_ip 100.64.0.0/10
    handle @tailscale {
      reverse_proxy localhost:5090
    }
    respond "Access denied" 403
  '';
  users.users.lldap = {
    name = "lldap";
    group = "lldap";
    description = "LDAP Server User";
    isSystemUser = true;
  };
  users.groups.lldap = {};

  systemd.services.lldap = {
    serviceConfig = {
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      DynamicUser = lib.mkForce false;
      User = "lldap";
      Group = "lldap";
    };
  };
  sops = {
    secrets = let
      owner = config.systemd.services.lldap.serviceConfig.User;
      group = config.systemd.services.lldap.serviceConfig.Group;
      restartUnits = ["lldap.service"];
      cfg = {
        inherit owner group restartUnits;
      };
    in {
      "lldap/jwt" = cfg;
      "lldap/seed" = cfg;
      "lldap/admin" = cfg;
    };
  };
}
