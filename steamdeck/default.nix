{pkgs, ...}: {
  imports = [
    ../home/programs/helix.nix
    ../home/programs/sops.nix
  ];
  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
    };
  };

  systemd.user.services = {
    nextcloudcmd = {
      Unit = {
        Description = "Nextcloud Client";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.nextcloud-client}/bin/nextcloudcmd -n /home/deck/Nextcloud https://cloud.darksailor.dev";
      };
    };
  };

  systemd.user.timers = {
    nextcloudcmd = {
      Unit = {
        Description = "Run Nextcloud Client every 5 minutes";
      };
      Timer = {
        OnCalendar = "*:0/5";
        Persistent = true;
      };
      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };

  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    packages = with pkgs; [
      _1password-cli
      just
    ];
    stateVersion = "24.11";
  };
}
