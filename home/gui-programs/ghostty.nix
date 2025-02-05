{
  pkgs,
  device,
  inputs,
  ...
}: {
  programs.ghostty = {
    enable = pkgs.stdenv.isLinux;
    installBatSyntax = false;
    settings = {
      theme = "catppuccin-mocha";
      # font-family = [
      #   ""
      #   "Hasklug Nerd Font Mono"
      # ];
      window-decoration = false;
      title = "";
      command = "fish";
      background-opacity = 0.8;
    };
    package = pkgs.ghostty;
  };
}
