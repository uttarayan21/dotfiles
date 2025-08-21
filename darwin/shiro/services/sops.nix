{
  # config,
  # pkgs,
  inputs,
  device,
  ...
}: {
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/Users/${device.user}/.config/sops/age/keys.txt";
  };
}
