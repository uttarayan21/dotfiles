{ ... }: {
  imports = [ ../modules/tuifeed.nix ];
  programs.tuifeed = {
    enable = true;
    config = {
      sources = {
        "r/rust" = "https://www.reddit.com/r/rust/.rss";
        "thesquareplanet" = "https://thesquareplanet.com/feed.xml";
        "Jon Gjengset (YouTube)" = "https://www.youtube.com/feeds/videos.xml?channel_id=UC_iD0xppBwwsrM9DegC5cQQ";
      };
    };
  };

}
