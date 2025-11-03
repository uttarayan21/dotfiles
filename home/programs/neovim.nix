{pkgs, ...}: {
  stylix.targets.nixvim.enable = false;
  programs.nixvim =
    {
      enable = true;
    }
    // (import ./../../neovim {inherit pkgs;});
}
