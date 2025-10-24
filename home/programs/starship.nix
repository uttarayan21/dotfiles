{
  pkgs,
  lib,
  device,
  ...
}: {
  stylix.targets.starship.enable = false;
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = let
      flavour = "mocha"; # Replace with your preferred palette
    in
      {
        # Check https://starship.rs/config/#prompt
        format = "$all$character";
        palette = "catppuccin_${flavour}";
        character = {
          success_symbol = "[[OK](bold green) ❯](maroon)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };
        directory = {
          truncation_length = 4;
          style = "bold lavender";
        };
      }
      // builtins.fromTOML (builtins.readFile
        (pkgs.catppuccinThemes.starship + /palettes/${flavour}.toml));
  };
}
