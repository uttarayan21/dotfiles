{
  inputs,
  device,
  ...
}: {
  imports = [inputs.vicinae.homeManagerModules.default];
  services.vicinae = {
    enable = device.is "ryu";
    autoStart = true;
    extensions = [];
  };
}
