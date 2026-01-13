{
  pkgs,
  device,
  lib,
  ...
}: {
  home.packages = with pkgs;
    lib.optionals (device.is "ryu") [
      nautilus
      totem
      ffmpegthumbnailer
      # polkit_gnome
      seahorse
      signal-desktop
      sony-headphones-client
      spotify
      steam-run
      wl-clipboard
    ];
}
