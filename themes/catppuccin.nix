{pkgs, ...}: let
  mkCatppuccin = {
    owner ? "catppuccin",
    version ? "0.0.1",
    item,
    rev ? "main",
    sha256 ? pkgs.lib.fakeSha256,
    override ? null,
  }:
    pkgs.stdenv.mkDerivation {
      inherit version override;
      pname = item;
      # TODO: Move to subflake
      # NOTE: It might not make sense to move this to subflake
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

  flavors = ["latte" "frappe" "macchiato" "mocha"];
  mapFlavor = flavorMap:
    (flavor: {
      name = flavor;
      value = flavorMap flavor;
    })
    flavors;
in {
  bat = mkCatppuccin {
    item = "bat";
    rev = "b19bea35a85a32294ac4732cad5b0dc6495bed32";
    sha256 = "sha256-POoW2sEM6jiymbb+W/9DKIjDM1Buu1HAmrNP0yC2JPg";
  };

  hyprland = mkCatppuccin {
    item = "hyprland";
    rev = "fc228737d3d0c12e34a7fa155a0fc3192e5e4017";
    sha256 = "sha256-9BhZq9J1LmHfAPBqOr64chiAEzS+YV6zqe9ma95V3no";
  };

  starship = mkCatppuccin {
    item = "starship";
    rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
    sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0";
  };

  fish = mkCatppuccin {
    item = "fish";
    rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
    sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg";
  };

  ironbar = mkCatppuccin {
    item = "waybar";
    rev = "v1.0";
    sha256 = "sha256-vfwfBE3iqIN1cGoItSssR7h0z6tuJAhNarkziGFlNBw";
  };
  newsboat = mkCatppuccin {
    item = "newsboat";
    rev = "be3d0ee1ba0fc26baf7a47c2aa7032b7541deb0f";
    sha256 = "sha256-czvR3bVZ0NfBmuu0JixalS7B1vf1uEGSTSUVVTclKxI";
  };

  # gtk = pkgs.catppuccin-gtk.override {
  #   variant = "mocha";
  #   size = "standard";
  #   accents = ["mauve"];
  #   tweaks = ["normal"];
  # };
  gtk = pkgs.catppuccin-gtk;

  papirus-folders = pkgs.catppuccin-papirus-folders.override {
    accent = "mauve";
    flavor = "mocha";
  };
}
