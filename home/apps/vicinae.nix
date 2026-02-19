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
  home.packages = with pkgs;
    lib.optionals (device.is "ryu") [
      # pulseaudio
      playerctl
    ];
}
