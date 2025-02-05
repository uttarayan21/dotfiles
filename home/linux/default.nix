{
  lib,
  device,
  ...
}: {
  imports =
    []
    ++ (lib.optionals device.hasGui [
      ./hyprland.nix
      ./gtk.nix
      ./anyrun.nix
      ./ironbar
      ./foot.nix
      ./mpd.nix
    ]);

  services.kdeconnect.enable = device.hasGui;
  services.kdeconnect.indicator = device.hasGui;
  services.swayosd.enable = device.hasGui;
  services.swaync.enable = device.hasGui;
  services.nextcloud-client = {
    enable = device.hasGui;
    startInBackground = true;
  };
}
