{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../modules/home/tailscale.nix
  ];
  services.tailscale.enable = true;
}
