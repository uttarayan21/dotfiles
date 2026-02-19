{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wine-wayland
    winetricks
    wineWowPackages.waylandFull
  ];
}
