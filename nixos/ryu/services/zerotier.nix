{...}: {
  services = {
    zerotierone = {
      enable = true;
      port = 9994;
      joinNetworks = [
        "abfd31bd4766754d"
      ];
    };
  };
}
