{device, ...}: {
  programs.weylus = {
    enable = true;
    users = [device.user];
    openFirewall = true;
  };
}
