{
  pkgs,
  lib,
  device,
  ...
}: {
  gtk = {
    enable = device.is "ryu";
    # theme = {
    #   name = "catppuccin-mocha-mauve-standard+normal";
    #   package = pkgs.catppuccinThemes.gtk;
    #   # package = pkgs.catppuccin-gtk.override {
    #   #   variant = "mocha";
    #   #   size = "standard";
    #   #   accents = ["mauve"];
    #   #   tweaks = ["normal"];
    #   # };
    # };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        accent = "mauve";
        flavor = "mocha";
      };
    };

    cursorTheme = {
      name = "Vanillay-DMZ";
      package = pkgs.vanilla-dmz;
    };

    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };
  home.packages = lib.optionals (device.is "ryu") [
    # pkgs.catppuccinThemes.gtk
    pkgs.catppuccinThemes.papirus-folders
  ];
}
