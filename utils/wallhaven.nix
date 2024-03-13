{ pkgs, ... }:
let
  getWall = { url, sha256 ? pkgs.lib.fakeSha256 }:
    builtins.fetchurl { inherit url sha256; };
in rec {
  inherit getWall;
  # Some predefined wallpapers
  lights = getWall {
    url = "https://w.wallhaven.cc/full/p2/wallhaven-p2el93.jpg";
    sha256 = "1fzxqdrxh7mbd18lgq1kqnzwf1nsgl7rj04idaq35cgf2fh0914v";
  };
  shapes = getWall {
    url = "https://w.wallhaven.cc/full/p8/wallhaven-p8o29m.jpg";
    sha256 = "005qrq6dnzzwia9v9cv69krkcn86zv44s3790mxv7dfzj09r5amq";
  };
  cloud = getWall {
    url = "https://w.wallhaven.cc/full/gp/wallhaven-gpv6rd.jpg";
    sha256 = "18hpaxwi1npcfkmyw42plivmjlpgvxgblp8fy2glxh7g1yxh6qds";
  };

  all = [ lights shapes cloud ];
}