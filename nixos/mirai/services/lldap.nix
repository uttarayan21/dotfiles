{config, ...}: {
  sops = {
    secrets = let
      user = config.systemd.services.lldap.serviceConfig.User;
    in {
      "ldap/aaa".owner = user;
    };
  };
  services = {
    lldap = {
      enable = true;
      settings = {
        http_host = "/var/run/lldb/lldb.sock";
        ldap_user_dn = "admin";
        ldap_base_dn = "dc=darksailor,dc=dev";
      };
    };
    caddy = {
      virtualHosts."ldap.darksailor.dev".extraConfig = ''
        reverse_proxy unix//var/run/lldb/lldb.sock
      '';
    };
  };
}
