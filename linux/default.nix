{ pkgs, device, nur, inputs, ... }: {
  imports = [
    ../common/firefox.nix
    ../linux/hyprland.nix
    ../linux/gtk.nix
    ../linux/anyrun.nix
    ../linux/ironbar
    ../linux/foot.nix
    ../linux/mpd.nix
  ];


  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
  services.swayosd.enable = true;
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  systemd.user.services.spotify-player = {
    Install = { WantedBy = [ "graphical-session.target" ]; };
    Unit = {
      Description = "Spotify Player Daemon";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.spotify-player}/bin/spotify_player -d";
      Restart = "on-failure";
      RestartSec = "5";
      User = "${device.user}";
    };
  };
}
