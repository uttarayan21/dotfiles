{ pkgs, ... }: {
  imports = [
    ../common/firefox.nix
    ../linux/hyprland.nix
    ../linux/gtk.nix
    ../linux/anyrun.nix
    ../linux/ironbar.nix
    ../linux/foot.nix
  ];
}
