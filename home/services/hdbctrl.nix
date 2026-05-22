{
  inputs,
  device,
  ...
}: {
  imports = [inputs.hdbctrl.homeManagerModules.default];

  # GUI flavor: tray icon + iced window. Window opens on login and on
  # left-click on the tray icon. Switch to `services.hdbctrl-tray` if you
  # only want the menu without a window. Enabling both fails an assertion
  # (they fight over the same StatusNotifierItem id).
  services.hdbctrl-gui = {
    enable = device.is "ryu";
    # Package is already installed system-wide via programs.hdbctrl in
    # nixos/ryu/apps/hdbctrl.nix; no need to duplicate it in home.packages.
    installPackage = false;
  };
}
