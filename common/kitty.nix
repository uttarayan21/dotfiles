{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Hasklug Nerd Font Mono";
      size = 13;
    };
    settings = {
      background_opacity = "0.8";
      background = "#000000";
      shell = "${pkgs.fish}/bin/fish";
    };
    shellIntegration.enableFishIntegration = true;
    theme = "Catppuccin-Mocha";
  };
}
