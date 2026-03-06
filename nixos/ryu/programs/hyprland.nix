{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
    xhost
  ];
}
