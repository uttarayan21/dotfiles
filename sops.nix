{device, ...}: {
  sops = {
    defaultSopsFile = secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${device.home}/.config/sops/age/keys.txt";
  };
}
