{
  pkgs,
  device,
  inputs,
  ...
}: {
  programs.kitty = {
    enable = true;
    # enable = false;
    font = {
      # name = "FiraCode Nerd Font Mono";
      # name = "Hasklug Nerd Font Mono";
      name = "Monaspace Krypton Var Light";
      size = 13;
    };
    settings = {
      background_opacity = "0.8";
      background = "#000000";
      shell = "${pkgs.fish}/bin/fish";
      hide_window_decorations = "yes";
    };
    shellIntegration.enableFishIntegration = true;
    darwinLaunchOptions = [
      "--single-instance"
    ];
    themeFile = "Catppuccin-Mocha";
    package = inputs.nixpkgs-master.legacyPackages.${device.system}.kitty;
  };
}
