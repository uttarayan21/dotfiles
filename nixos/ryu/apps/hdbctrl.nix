{
  device,
  inputs,
  ...
}: {
  # Sennheiser HDB 630 control: CLI (`hdbctrl`) + GTK tray (`hdbctrl-gui`).
  # Talks GAIA v3 over BlueZ RFCOMM; needs `hardware.bluetooth.enable`
  # (already on for ryu) and the user in group "bluetooth".
  environment.systemPackages = [
    inputs.hdbctrl.packages.${device.system}.default
  ];
}
