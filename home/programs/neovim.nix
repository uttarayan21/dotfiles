{pkgs, ...}: {
  stylix.targets.nixvim.enable = false;
  programs.nixvim =
    {
      enable = true;
      nixpkgs = {
        config = {
          allowUnfree = true;
        };
      };
    }
    // (import ./../../neovim {inherit pkgs;});
}
