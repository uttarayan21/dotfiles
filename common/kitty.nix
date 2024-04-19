{
  pkgs,
  device,
  ...
}: {
  programs.kitty = {
    enable = device.hasGui;
    font = {
      name = "Hasklug Nerd Font Mono";
      # name = "Monaspace Krypton Var Light";
      size = 13;
    };
    settings = {
      background_opacity = "0.8";
      background = "#000000";
      shell = "${pkgs.fish}/bin/fish";
      hide_window_decorations = "yes";
      # font_family = "Hasklug Nerd Font Mono";
      # font_size = 13.0;
    };
    shellIntegration.enableFishIntegration = true;
    darwinLaunchOptions = [
      "--single-instance"
    ];
    theme = "Catppuccin-Mocha";
  };
}
