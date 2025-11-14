{
  lib,
  pkgs,
  # device,
  # inputs,
  ...
}: {
  stylix.targets.kitty.enable = false;
  programs.kitty = {
    enable = true;
    # enable = false;
    font = {
      # name = "FiraCode Nerd Font Mono";
      name = "Hasklug Nerd Font Mono";
      # name = "Monaspace Krypton Var Light";
      size = lib.mkForce 13;
    };
    settings = {
      background_opacity = lib.mkForce "0.8";
      background = lib.mkForce "#000000";
      shell = "${pkgs.fish}/bin/fish";
      hide_window_decorations = "yes";
      cursor_trail = 1;
      close_on_child_death = "yes";
    };
    shellIntegration.enableFishIntegration = true;
    darwinLaunchOptions = [
      "--single-instance"
    ];
    themeFile = lib.mkForce "Catppuccin-Mocha";
    # package = inputs.nixpkgs-stable.legacyPackages.${device.system}.kitty;
  };
}
