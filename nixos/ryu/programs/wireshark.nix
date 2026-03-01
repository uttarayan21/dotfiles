{
  pkgs,
  device,
  ...
}: {
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
  };
  users.users.${device.user}.extraGroups = ["wireshark"];
}
