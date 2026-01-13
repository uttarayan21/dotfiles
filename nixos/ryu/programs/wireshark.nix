{
  pkgs,
  device,
  ...
}: {
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
  };
  environment.systemPackages = with pkgs; [
    wireshark-qt
  ];
  users.users.${device.user}.extraGroups = ["wireshark"];
}
