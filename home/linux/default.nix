{
  lib,
  device,
  pkgs,
  ...
}:
lib.optionalAttrs (pkgs.stdenv.isLinux && device.hasGui) {
  imports = [
    ./hyprland.nix
    ./gtk.nix
    ./anyrun.nix
    ./ironbar
    ./foot.nix
    ./mpd.nix
    ./gui.nix
  ];

  services.kdeconnect.enable = device.hasGui;
  services.kdeconnect.indicator = device.hasGui;
  services.swayosd.enable = device.hasGui;
  services.swaync.enable = device.hasGui;
  # services.nextcloud-client = {
  #   enable = device.hasGui;
  #   startInBackground = true;
  # };
}
