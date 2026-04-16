{
  device,
  pkgs,
  ...
}: {
  programs.codex = {
    enable = !device.isServer;
    package = pkgs.codex;
  };
}
