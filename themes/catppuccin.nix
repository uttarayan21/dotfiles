{
  pkgs,
  inputs,
  ...
}: let
  mkCatppuccin = {
    item,
    src,
    version ? "0.0.1",
    override ? null,
  }:
    pkgs.stdenv.mkDerivation {
      inherit version override src;
      pname = item;
      buildPhase = ''
        echo "Building Cattppucin for ${item}..."
        mkdir -p $out
        cp -r ./* $out/
      '';
    };
in {
  bat = mkCatppuccin {
    item = "bat";
    src = inputs.catppuccin-bat;
  };

  hyprland = mkCatppuccin {
    item = "hyprland";
    src = inputs.catppuccin-hyprland;
  };

  starship = mkCatppuccin {
    item = "starship";
    src = inputs.catppuccin-starship;
  };

  fish = mkCatppuccin {
    item = "fish";
    src = inputs.catppuccin-fish;
  };

  ironbar = mkCatppuccin {
    item = "waybar";
    src = inputs.catppuccin-waybar;
  };

  newsboat = mkCatppuccin {
    item = "newsboat";
    src = inputs.catppuccin-newsboat;
  };

  # https://github.com/catppuccin/yazi
  yazi = mkCatppuccin {
    item = "yazi";
    src = inputs.catppuccin-yazi;
  };

  gtk = pkgs.catppuccin-gtk.override {
    variant = "mocha";
    size = "standard";
    accents = ["mauve"];
    tweaks = ["normal"];
  };

  papirus-folders = pkgs.catppuccin-papirus-folders.override {
    accent = "mauve";
    flavor = "mocha";
  };
}
