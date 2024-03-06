{ pkgs, ... }:
let
  mkCatppuccin =
    { owner ? "catppuccin"
    , version ? "0.0.1"
    , item
    , rev ? "main"
    , sha256 ? pkgs.lib.fakeSha256
    }:
    pkgs.stdenv.mkDerivation {
      inherit version;
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

  fish = mkCatppuccin {
    item = "fish";
    sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg";
  };
}
