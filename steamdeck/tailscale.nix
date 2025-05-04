{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../modules/home/tailscale.nix
  ];
  services.tailscale = {
    enable = false;
  };

  home.packages = [
    pkgs.tailscale
  ];
}
