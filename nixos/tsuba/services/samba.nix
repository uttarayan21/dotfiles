{...}: {
  services = {
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "tsuba";
          "netbios name" = "tsuba";
          "security" = "user";
          # "hosts allow" = "192.168.0. 127.0.0.1 localhost ";
          # "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
          "min protocol" = "SMB2";
          "max protocol" = "SMB3";
        };

        nas = {
          "path" = "/volumes/media";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          # "force user" = "username";
          # "force group" = "groupname";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
  networking.firewall.allowPing = true;
}
