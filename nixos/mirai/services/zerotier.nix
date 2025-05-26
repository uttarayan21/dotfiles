{config, ...}: {
  # sops = {
  #   secrets."zerotier/api_key".owner = config.systemd.services.zeronsd-abfd31bd4766754d.serviceConfig.User;
  # };
  # services.zerotierone = {
  #   enable = true;
  #   port = 9994;
  #   joinNetworks = [
  #     "abfd31bd4766754d"
  #   ];
  # };
  # services.zeronsd = {
  #   servedNetworks = {
  #     abfd31bd4766754d = {
  #       settings = {
  #         log_level = "trace";
  #         local_url = "http://127.0.0.1:9994";
  #         domain = "zt.darksailor.dev";
  #         token = config.sops.secrets."zerotier/api_key".path;
  #       };
  #     };
  #   };
  # };
}
