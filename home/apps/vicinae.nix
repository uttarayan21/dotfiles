{
  pkgs,
  inputs,
  device,
  ...
}: {
  imports = [inputs.vicinae.homeManagerModules.default];
  services.vicinae = {
    enable = device.is "ryu";
    systemd = {
      enable = true;
      autoStart = true;
    };
  };
  home.packages = with pkgs; [
    # pulseaudio
    playerctl
  ];
}
