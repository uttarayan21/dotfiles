{
  pkgs,
  device,
  ...
}: {
  programs.ghostty = {
    enable = device.is "ryu";
    installBatSyntax = false;
    settings = {
      font-family = [
        "Hasklug Nerd Font Mono"
      ];
      window-decoration = false;
      title = "";
      command = "fish";
      background-opacity = 0.8;
    };
  };
}
