{config, ...}: {
  sops = {
    secrets."zerotier/api_key".owner = config.systemd.services.zeronsd-abfd31bd4766754d.serviceConfig.User;
  };
  services .zerotierone = {
    enable = true;
    port = 9994;
    joinNetworks = [
      "abfd31bd4766754d"
    ];
  };
}
