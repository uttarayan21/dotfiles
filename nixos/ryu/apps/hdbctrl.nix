{
  inputs,
  ...
}: {
  # Sennheiser HDB 630 control: CLI (`hdbctrl`), iced window (`hdbctrl-gui`),
  # and ksni tray (`hdbctrl-tray`). Talks GAIA v3 over BlueZ RFCOMM; needs
  # `hardware.bluetooth.enable` (already on for ryu) and the user in the
  # `bluetooth` group.
  imports = [inputs.hdbctrl.nixosModules.default];

  # Installs the package system-wide. Tray autostart is left to
  # home-manager (see ../../../home/services/hdbctrl.nix) so it can be
  # toggled per-user without rebuilding the system.
  programs.hdbctrl.enable = true;
}
