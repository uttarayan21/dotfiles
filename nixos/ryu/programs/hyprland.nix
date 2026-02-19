{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    hyprland
    xorg.xhost
  ];
}
