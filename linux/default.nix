{
  pkgs,
  lib,
  device,
  ...
}: {
  imports =
    []
    ++ (lib.optionals device.hasGui [
      ../common/firefox.nix
      ../linux/hyprland.nix
      ../linux/gtk.nix
      ../linux/anyrun.nix
      ../linux/ironbar
      ../linux/foot.nix
      ../linux/mpd.nix
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
