{ pkgs, ... }:
let
  mkCatppuccin = { owner ? "catppuccin", item, rev ? "main", sha256 ? pkgs.lib.fakeSha256 }:
    pkgs.stdenv.mkDerivation {
      pname = item;
      version = "0.0.1";
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
in
{

  bat = mkCatppuccin {
    item = "bat";
    sha256 = "sha256-PLbTLj0qhsDj+xm+OML/AQsfRQVPXLYQNEPllgKcEx4";
  };

  hyprland = mkCatppuccin {
    item = "hyprland";
    sha256 = "sha256-9BhZq9J1LmHfAPBqOr64chiAEzS+YV6zqe9ma95V3no";
  };

  starship = mkCatppuccin {
    item = "starship";
    sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0";
  };
}