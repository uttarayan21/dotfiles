{
  pkgs,
  device,
  ...
}: {
  programs.kitty = {
    enable = device.hasGui;
    font = {
      name = "FiraCode Nerd Font Mono";
      # name = "Hasklug Nerd Font Mono";
      # name = "Monaspace Krypton Var Light";
      size = 13;
    };
    settings = {
      background_opacity = "0.8";
      background = "#000000";
      shell = "${pkgs.fish}/bin/fish";
      hide_window_decorations = "yes";
      symbol_map = "U+22c4 Symbols Nerd Font Mono";
    };
    shellIntegration.enableFishIntegration = true;
    darwinLaunchOptions = [
      "--single-instance"
    ];
    theme = "Catppuccin-Mocha";
  };
}
