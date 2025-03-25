{
  pkgs,
  device,
  ...
}: let
  linux_gui = device.hasGui && pkgs.stdenv.isLinux;
in {
  imports = [
    ./hyprland.nix
    ./gtk.nix
    ./anyrun.nix
    ./ironbar
    ./gui.nix
  ];

  services.kdeconnect.enable = linux_gui;
  services.kdeconnect.indicator = linux_gui;
  services.swayosd.enable = linux_gui;
  services.swaync.enable = linux_gui;
  # services.nextcloud-client = {
  #   enable = device.hasGui;
  #   startInBackground = true;
  # };
}
