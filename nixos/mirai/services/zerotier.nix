{config, ...}: {
  sops = {
    secrets."zerotier/api_key".owner = config.users.users.zeronsd.name;
  };
  services.zerotierone = {
    enable = true;
    port = 9994;
    joinNetworks = [
      "abfd31bd4766754d"
    ];
  };
  services.zeronsd = {
    servedNetworks = {
      abfd31bd4766754d = {
        settings = {
          domain = "zt.darksailor.dev";
          token = config.sops.secrets."zerotier/api_key".path;
        };
      };
    };
  };
}
