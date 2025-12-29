{
  inputs,
  device,
  ...
}: {
  imports = [
    inputs.eilmeldung.homeManager.default
  ];
  programs.eilmeldung = {
    enable = device.is "ryu";

    settings = {
      refresh_fps = 60;
      article_scope = "unread";

      theme = {
        color_palette = {
          background = "#1e1e2e";
          # // ...
        };
      };

      input_config.mappings = {
        "q" = ["quit"];
        "j" = ["down"];
        "k" = ["up"];
        "g g" = ["gotofirst"];
        "G" = ["gotolast"];
        "o" = ["open" "read" "nextunread"];
      };

      feed_list = [
        "query: \"Today Unread\" today unread"
        "query: \"Today Marked\" today marked"
        "feeds"
        "* categories"
        "tags"
      ];
    };
  };
}
