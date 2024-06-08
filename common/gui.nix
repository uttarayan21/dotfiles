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
      # neovide
    ]
    ++ lib.optionals device.isLinux [
      _1password
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
  # import the home-manager module
  imports = [inputs._1password-shell-plugins.hmModules.default];
  programs = {
    _1password-shell-plugins = {
      # enable 1Password shell plugins for bash, zsh, and fish shell
      enable = true;
      # the specified packages as well as 1Password CLI will be
      # automatically installed and configured to use shell plugins
      plugins = with pkgs; [gh awscli2 cachix];
    };
  };
}
