{pkgs, ...}: {
  systemd.user.services.sunshine.path = [
    pkgs.gamemode
    pkgs.steam
  ];

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    autoStart = true;
    settings = {
      # file_apps = "/home/servius/.config/sunshine/apps.json";
      sunshine_name = "Ryu";
    };
    applications = {
      # env = {PATH = "/run/current-system/sw/bin";};
      apps = [
        {
          name = "Steam Big Picture";
          icon = "steam";
          # detached = ["setsid steam steam://open/gamepadui"];
          detached = ["/run/wrappers/bin/sudo -u servius ${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam://open/gamepadui"];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "Baldur's Gate 3";
          image-path = "/home/servius/.config/sunshine/covers/igdb_119171.png";
          auto-detach = "true";
          exclude-global-prep-cmd = "false";
          prep-cmd = [];
          # detached = ["setsid steam steam://rungameid/1086940"];
          detached = ["/run/wrappers/bin/sudo -u servius ${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam://rungameid/1086940"];
          wait-all = true;
          exit-timeout = 5;
        }
      ];
    };
  };
}
