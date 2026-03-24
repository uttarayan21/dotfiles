{inputs, ...}: {
  imports = [inputs.aagl.nixosModules.default];
  nix.settings = inputs.aagl.nixConfig;
  programs.anime-game-launcher.enable = true;
}
