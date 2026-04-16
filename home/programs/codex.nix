{
  device,
  pkgs,
  ...
}: {
  programs.codex = {
    enable = device.is "ryu" || device.is "kuro";
    package = pkgs.codex;
  };
}
