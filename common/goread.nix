{...}: {
  imports = [../modules/goread.nix];
  programs.goread = {
    enable = true;
    config = {
      urls = {
        categories = [
          {
            name = "Rust";
            desc = "Stuff related to the rust programming language";
            subscriptions = [
              {
                name = "r/rust";
                desc = "The rust subreddit";
                url = "https://old.reddit.com/r/rust/.rss";
              }
              {
                name = "thesquareplanet";
                desc = "jonhoo's blog";
                url = "https://thesquareplanet.com/feed.xml";
              }
              {
                name = "Jon Gjengset's Youtube";
                desc = "jonhoo's youtube channel";
                url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC_iD0xppBwwsrM9DegC5cQQ";
              }
            ];
          }
          {
            name = "Nix";
            desc = "Stuff related to the nix / nixos / nixlang";
            subscriptions = [
              {
                name = "r/nixos";
                desc = "The nixos subreddit";
                url = "https://old.reddit.com/r/nixos/.rss";
              }
            ];
          }
        ];
      };
    };
  };
}
