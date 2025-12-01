{inputs, ...}: {
  imports = [inputs.vicinae.homeManagerModules.default];
  services.vicinae = {
    enable = true;
    autoStart = true;
    extensions = [];
  };
}
