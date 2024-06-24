{
  pkgs,
  device,
  lib,
  ...
}:
lib.attrsets.optionalAttrs device.hasGui {
  systemd.user.services._1password-gui = {
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
  home.packages = with pkgs;
    [
      via
      # _1password-gui
      # neovide
    ]
    ++ lib.optionals device.isLinux [
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
      mullvad-browser
      steam-run

      webcord-vencord
      spotify
      wl-clipboard
    ];
}
