{
  device,
  masterPkgs,
  ...
}: {
  programs.codex = {
    enable = device.is "ryu" || device.is "kuro";
    package = masterPkgs.codex;
  };
}
