{
  config,
  lib,
  ...
}: {
  services.lldap = {
    enable = true;
    settings = {
      ldap_user_dn = "admin";
      ldap_base_dn = "dc=darksailor,dc=dev";
      ldap_user_email = "admin@darksailor.dev";
      http_host = "0.0.0.0";
      http_port = 5090;
      ldap_port = 389;
      ldap_host = "0.0.0.0";
      environment = {
        LLDAP_JWT_SECRET_FILE = config.sops.secrets."lldap/jwt".path;
        LLDAP_KEY_SEED_FILE = config.sops.secrets."lldap/seed".path;
        LLDAP_LDAP_USER_PASS_FILE = config.sops.secrets."lldap/admin".path;
      };
    };
  };
  services.caddy = {
    virtualHosts."console.darksailor.dev".extraConfig = ''
      reverse_proxy localhost:5090
    '';
  };
  users.users.lldap = {
    name = "lldap";
    group = "lldap";
    description = "LDAP Server User";
    isSystemUser = true;
  };
  users.groups.lldap = {};

  # systemd.services.sops-install-secrets = {
  #   after = ["lldap.service"];
  # };

  systemd.services.lldap = {
    # wants = ["sops-install-secrets.service"];
    serviceConfig = {
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      DynamicUser = lib.mkForce false;
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
