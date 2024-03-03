{ pkgs, flavor, ... }:
let
  mkCatppuccin = { owner ? "catppuccin", item, rev ? "main", sha256 ? pkgs.lib.fakeSha256 }:
    pkgs.stdenv.mkDerivation {
      pname = item;
      version = "0.0.1";
      src = pkgs.fetchFromGitHub {
        inherit owner rev sha256;
        repo = item;
      };
    };
in
{

  bat = mkCatppuccin {
    item = "bat";
  };

  hyprland = mkCatppuccin {
    item = "hyprland";
  };

  starship = mkCatppuccin {
    item = "starship";
  };
}
