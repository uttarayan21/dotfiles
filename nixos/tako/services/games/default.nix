{pkgs, ...}: {
  imports = [
    # ./minecraft.nix
    # ./satisfactory.nix
    ./terraria.nix
  ];

  environment.systemPackages = with pkgs; [
    steamcmd
    steam-tui
  ];
}
