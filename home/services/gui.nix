{
  pkgs,
  device,
  lib,
  ...
}: {
  systemd.user.services.onepassword-gui = lib.optionalAttrs (device.is "ryu") {
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
    lib.optionals (device.is "ryu") [
      nautilus
      totem
      ffmpegthumbnailer
      polkit_gnome
      seahorse
      signal-desktop
      # sony-headphones-client
      spotify
      steam-run
      wl-clipboard
      (prismlauncher.override {
        additionalPrograms = [ffmpeg zenity];
        jdks = [
          graalvm-ce
          zulu8
          zulu17
          zulu
        ];
      })
    ];
}
