{...}: {
  services = {
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "Shiro";
          "netbios name" = "Shiro";
          "security" = "user";
          "hosts allow" = "192.168.11. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };

        public = {
          "path" = "/Volumes/External SS";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          # "force user" = "username";
          # "force group" = "groupname";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      # openFirewall = true;
    };
  };
  # networking.firewall.allowPing = true;
}
