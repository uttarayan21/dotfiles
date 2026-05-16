{
  device,
  inputs,
  ...
}: {
  home-manager.users.${device.user}.home.packages = [
    inputs.slo.packages.${device.system}.default
  ];
}
