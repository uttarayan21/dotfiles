{device, ...}: {
  programs.eww = {
    enable = device.is "ryu";
    enableFishIntegration = true;
    configDir = ./eww;
  };
}
