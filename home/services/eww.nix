{
  device,
  config,
  ...
}: {
  programs.eww = {
    enable = device.is "ryu";
    enableFishIntegration = true;
  };
  # xdg.configFile = {
  #   eww = {
  #     source = "${config.home.homeDirectory}/Projects/dotfiles/home/services/eww";
  #   };
  # };
}
