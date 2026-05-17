{
  device,
  inputs,
  ...
}: {
  environment.systemPackages = [
    inputs.slo.packages.${device.system}.default
  ];
}
