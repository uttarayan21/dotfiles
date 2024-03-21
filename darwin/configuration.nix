{pkgs, ...}: {
  imports = [./yabai.nix ./skhd.nix];
  environment.systemPackages = with pkgs; [nix neovim];
      trusted-users = ["root" "fs0c131y"];