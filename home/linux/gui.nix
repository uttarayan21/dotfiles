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
      jdk
      mullvad-closest
      mullvad-vpn
      nautilus
      totem
      ffmpegthumbnailer
      polkit_gnome
      seahorse
      signal-desktop
      sony-headphones-client
      spotify
      steam-run
      wl-clipboard
      zed-editor
      webcord
      prismlauncher
    ];
}
