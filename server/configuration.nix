{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub = {
  #   # no need to set devices, disko will add all devices that have a EF02 partition to the list already
  #   # devices = [ ];
  #   efiSupport = true;
  #   efiInstallAsRemovable = true;
  # };
  services.openssh.enable = true;
  networking.useDHCP = lib.mkDefault true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMh7ohX3cIB/euZwy9hk8iKywlu+koHrOiyaEG/ubr7Lfr+d92HV8arAIow52VMzv17sUBiP8Us/13FTtlLNKle7VXi5Eh+BBzNjOU/bpDKe4XZQtiEnnVd7LzLaAYfS+Gg9cD9hG3GGaxPYe8iN5bfpR1l15ccUTPHvBtefAoPax5bnMd89Z82stWvnpFs42YtP5VXLwMjk2nZhst1AspXMFxvsg/vkniMun+SuzyoQGkEo+ncTEmQzEQF5JpWEsfBdhmcOJnWoIWNcaWTAmVbF4Xkv5GqtdibXykVjlTUtrsVrBvvTL+BfQ99qiCafyWIhQgULDqXY2Ocq6mK9ZBohDzzsR0W/TXvRVIShfaRK6qmArcr4dSGQpd2H7/dJtpM9xHXSSyGhNHrlRFCTLBjHxjYrax9JzeRIWFSpNGOl3rUmI0P3FZJLBP9P6DJ9wJiksWD3kDRjaMQmr3gZhqAq6qYZIkSHiW1tLqcCncEFCdb/x5XJzkqEv3wPbKD1t4D0iBvSaFRaJTiTr611MlkS69T/5JCJW5RQoxE9qTV7X6WiQUToll/NqQ6Ox5mlQbj/zv4gFQq0CEHm/EgemHzHXatkMbV8ze/JHZFs3kxqaL6881yfVYWQIT8UbFZNdvJUd+VLWF5PpnXBWEH0+yPXttTyNSirztr1deTbZhDw=="
  ];

  system.stateVersion = "24.05";
}
