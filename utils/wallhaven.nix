{pkgs, ...}: let
  getWall = {
    url,
    sha256 ? pkgs.lib.fakeSha256,
  }:
    builtins.fetchurl {inherit url sha256;};
in rec {
  inherit getWall;
  # Some predefined wallpapers
  moon = getWall {
    url = "https://w.wallhaven.cc/full/6o/wallhaven-6o1zp7.png";
    sha256 = "07c1yc3haa25ik3icqm85ppb5x888adxcyh9pmyz79n7ma8z7sil";
  };
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
  frieren_3 = getWall {
    url = "https://w.wallhaven.cc/full/jx/wallhaven-jxqml5.jpg";
    sha256 = "0vm02yg4w5bfqns5k1r8y09fqxs0qy4y886myvnp64n1maaihp4k";
  };
  skull = getWall {
    url = "https://w.wallhaven.cc/full/85/wallhaven-856dlk.png";
    sha256 = "11w5lfqg6ip6zhiwfw63gv08f55kqbfnhmv7iq07mfspny36w840";
  };

  anime = [frieren_3];
  all = [lights shapes cloud skull moon] ++ anime;
}
