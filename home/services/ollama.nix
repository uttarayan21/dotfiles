{
  pkgs,
  device,
  ...
}: {
  services.ollama.enable = device.is "shiro";
}
