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

  home.packages = with pkgs;
    []
    ++ lib.optionals device.hasGui [
      discord
      (mpv-unwrapped.wrapper {mpv = mpv-unwrapped.override {sixelSupport = true;};})
      abaddon
      ferdium
      jdk
      mullvad-closest
      mullvad-vpn
      nautilus
      nextcloud-client
      polkit_gnome
      psst
      seahorse
      signal-desktop
      slack
      sony-headphones-client
      spotify
      steam-run
      via
      wl-clipboard
      zed-editor
      webcord
    ];
}
