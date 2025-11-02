{pkgs, ...}: {
  programs.nixvim =
    {
      enable = true;
    }
    // (import ./../../neovim {inherit pkgs;});
}
