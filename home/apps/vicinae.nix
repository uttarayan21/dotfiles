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
    extensions = [];
    settings = {
      theme = {
        dark = {
          name = "catppuccin-mocha";
        };
      };
    };
    # package = pkgs.vicinae.overrideAttrs (old: {
    #   patches = [../../patches/vicinae-ctrl-np.patch];
    # });
  };
}
