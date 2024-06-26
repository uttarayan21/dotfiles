{
  pkgs,
  device,
  lib,
  ...
}:
lib.attrsets.optionalAttrs device.hasGui {
  systemd.user.services._1password-gui = lib.optionalAttrs pkgs.stdenv.isDarwin {
    Unit = {
      Description = "1Password GUI";
      BindsTo = ["graphical-session.target"];
      After = ["graphical-session-pre.target"];
    };

    Service = {
      ExecStart = "${pkgs._1password-gui}/bin/1password";
      Restart = "always";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
  home.file = {
    "Applications/1Password.app".source = "${pkgs._1password-gui}/Applications/1Password.app";
  };
  home.packages = with pkgs;
    [
      _1password
    ]
    ++ lib.optionals device.isLinux [
      via
      discord
      bottles
      # minecraft
      jdk
      ferdium
      psst
      sony-headphones-client
      abaddon
      catppuccinThemes.gtk
      catppuccinThemes.papirus-folders

      gnome.seahorse
      gnome.nautilus
      nextcloud-client
      gparted
      polkit_gnome

      mullvad-vpn
      mullvad-closest
      steam-run

      webcord-vencord
      spotify
      wl-clipboard
    ];
}
