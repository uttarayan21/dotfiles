{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = {
      format = "$all$character";
      character = {
        success_symbol = "[[OK](bold green) ❯](maroon)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };
      directory = {
        truncation_length = 4;
        style = "bold lavender";
      };
    };
  };
}
