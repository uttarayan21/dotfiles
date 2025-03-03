{...}: {
  services = {
    polaris = {
      enable = false;
      port = 5050;
      settings = {
        mount_dirs = [
          {
            name = "Music";
            source = "/media/music";
          }
        ];
      };
    };
    caddy = {
      virtualHosts."music.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:5050
      '';
    };
  };
}
