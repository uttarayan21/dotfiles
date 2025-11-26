{pkgs, ...}: {
  services = {
    openvscode-server = {
      enable = true;
      port = 3000;
      host = "0.0.0.0";
      extraPackages = with pkgs; [];
      withoutConnectionToken = true;
    };
    caddy = {
      virtualHosts."code.darksailor.dev".extraConfig = ''
        import auth
        reverse_proxy localhost:3000
      '';
    };
  };
}
