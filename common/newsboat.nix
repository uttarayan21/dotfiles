{ pkgs, ... }: {
  programs.newsboat = {
    enable = false;
    urls = [
      {
        title = "r/rust";
        url = "https://www.reddit.com/r/rust/.rss";
        tags = [ "rust" ];
      }
      {
        title = "the square planet";
        url = "https://thesquareplanet.com/feed.xml";
        tags = [ "rust" ];
      }
      {
        title = "Jon Gjengset's YouTube";
        url =
          "https://www.youtube.com/feeds/videos.xml?channel_id=UC_iD0xppBwwsrM9DegC5cQQ";
        tags = [ "rust" "youtube" ];
      }
    ];
    extraConfig =
      let
        dracula = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/dracula/newsboat/main/newsboat";
          sha256 = "sha256:08b00ilc5zk5fkzqqd6aghcpya3d00s9kvv65b8c50rg7ikm88xr";
        };
      in
      ''
        include ${dracula}
        unbind-key g
        bind-key g home
        unbind-key G
        bind-key G end

        unbind-key h
        unbind-key j
        unbind-key k
        unbind-key l

        bind-key h quit
        bind-key j down
        bind-key k up
        bind-key l open
      '';
    browser = "${pkgs.handlr-xdg}/bin/xdg-open";
    maxItems = 50;
    autoReload = true;
  };
}
