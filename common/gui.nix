{
  pkgs,
  device,
  lib,
  ...
}:
lib.attrsets.optionalAttrs device.hasGui {
  systemd.user.services.onepassword-gui = lib.optionalAttrs pkgs.stdenv.isLinux {
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
  # home.file = lib.optionalAttrs device.isMac {
  #   "Applications/1Password.app".source = "${pkgs._1password-gui}/Applications/1Password.app";
  # };
  home.packages = with pkgs;
    [
      _1password
      neovide
      (mpv-unwrapped.wrapper {mpv = mpv-unwrapped.override {sixelSupport = true;};})
    ]
    ++ lib.optionals device.isLinux [
      slack
      via
      webcord-vencord
      bottles
      # minecraft
      jdk
      ferdium
      psst
      sony-headphones-client
      abaddon
      catppuccinThemes.gtk
      catppuccinThemes.papirus-folders

      signal-desktop

      seahorse
      nautilus
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
