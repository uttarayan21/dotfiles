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
        forward_auth localhost:5555 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
        }
        reverse_proxy localhost:3000
      '';
    };
  };
}
