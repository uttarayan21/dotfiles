{
  pkgs,
  inputs,
  device,
  ...
}: {
  imports = [inputs.vicinae.homeManagerModules.default];
  services.vicinae = {
    enable = device.is "ryu";
    systemd.autoStart = true;
    extensions = [];
    # package = pkgs.vicinae.overrideAttrs (old: {
    #   patches = [../../patches/vicinae-ctrl-np.patch];
    # });
  };
}
