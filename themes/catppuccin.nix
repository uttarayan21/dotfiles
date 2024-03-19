{ pkgs, ... }:
let
  mkCatppuccin =
    { owner ? "catppuccin"
    , version ? "0.0.1"
    , item
    , rev ? "main"
    , sha256 ? pkgs.lib.fakeSha256
    , override ? null
    }:
    pkgs.stdenv.mkDerivation {
      inherit version override;
      pname = item;
      src = pkgs.fetchFromGitHub {
        inherit owner rev sha256;
        repo = item;
      };
      buildPhase = ''
        echo "Building Cattppucin for ${item}..."
        mkdir -p $out
        cp -r ./* $out/
      '';
    };

  flavors = [ "latte" "frappe" "macchiato" "mocha" ];
  mapFlavor = flavorMap: (flavor: {
    name = flavor;
    value = flavorMap flavor;
  }) flavors;
in
{
  bat = mkCatppuccin {
    item = "bat";
    sha256 = "sha256-yHt3oIjUnljARaihalcWSNldtaJfVDfmfiecYfbzGs0";
  };

  hyprland = mkCatppuccin {
    item = "hyprland";
    sha256 = "sha256-9BhZq9J1LmHfAPBqOr64chiAEzS+YV6zqe9ma95V3no";
  };

  starship = mkCatppuccin {
    item = "starship";
    sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0";
  };

  fish = mkCatppuccin {
    item = "fish";
    sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg";
  };

  ironbar = mkCatppuccin {
    item = "waybar";
    rev = "v1.0";
    sha256 = "sha256-vfwfBE3iqIN1cGoItSssR7h0z6tuJAhNarkziGFlNBw";
  };
  newsboat = mkCatppuccin {
    item = "newsboat";
    rev = "main";
    sha256 = "sha256-czvR3bVZ0NfBmuu0JixalS7B1vf1uEGSTSUVVTclKxI";
  };

  gtk = (pkgs.catppuccin-gtk.override {
    variant = "mocha";
    size = "standard";
    accents = [ "mauve" ];
    tweaks = [ "normal" ];
  });

  papirus-folders = (pkgs.catppuccin-papirus-folders.override {
    accent = "mauve";
    flavor = "mocha";
  });
}
