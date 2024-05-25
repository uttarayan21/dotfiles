{
  pkgs,
  device,
  lib,
  ...
}:
lib.attrsets.optionalAttrs device.hasGui {
  home.packages = with pkgs;
    [
      neovide
    ]
    ++ lib.optionals device.isLinux [
      bottles
      # minecraft
      jdk
      ferdium
      psst
      sony-headphones-client
      abaddon
      catppuccinThemes.gtk
      catppuccinThemes.papirus-folders

      gnome.seahorse
      gnome.nautilus
      nextcloud-client
      gparted
      polkit_gnome

      mullvad-vpn
      mullvad-closest
      mullvad-browser
      steam-run

      webcord-vencord
      spotify
      wl-clipboard
    ];
}
