{
  pkgs,
  device,
  lib,
  inputs,
  ...
}:
lib.attrsets.optionalAttrs device.hasGui {
  home.packages = with pkgs;
    [
      _1password
      # neovide
    ]
    ++ lib.optionals device.isLinux [
      _1password-gui
      bitwarden
      discord
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
