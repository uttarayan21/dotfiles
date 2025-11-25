{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    dualsensectl
  ];
  services.udev.extraRules = ''
    # USB
    ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    # Bluetooth
    ATTRS{name}=="DualSense Wireless Controller", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
}
