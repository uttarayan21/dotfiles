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
      http_host = "127.0.0.1";
      http_port = 5090;
      ldap_port = 389;
      ldap_host = "::";
      ldap_user_pass_file = config.sops.secrets."lldap/admin".path;
      environmentFile = ''
        LLDAP_JWT_SECRET_FILE = ${config.sops.secrets."lldap/jwt".path};
        LLDAP_KEY_SEED_FILE = ${config.sops.secrets."lldap/seed".path};
      '';
    };
  };
  # services.caddy = {
  #   # virtualHosts."ldap.darksailor.dev".extraConfig = ''
  #   #   reverse_proxy localhost:5090
  #   # '';
  # };
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
