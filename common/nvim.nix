{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];
  programs.nixvim =
    pkgs.sneovim.config
    // {
      enable = true;
    };
}
