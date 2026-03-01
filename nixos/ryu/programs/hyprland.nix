{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    hyprland
    xhost
  ];
}
