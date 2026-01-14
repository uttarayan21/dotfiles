# docker run --rm -it \
# -p 8000:8000 \
# -e "KELLNR_ORIGIN__HOSTNAME=kellnr.example.com" \
# -v $(pwd):/opt/kdata ghcr.io/kellnr/kellnr:5
{...}: let
  port = 8899;
  domain = "crates.darksailor.dev";
in {
  sops = {
  };
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      kellnr = {
        image = "ghcr.io/kellnr/kellnr:5";
        ports = ["127.0.0.1:${toString port}:8000"];
        volumes = [
          "/var/lib/kellnr:/opt/kdata"
        ];
        environment = {
          KELLNR_ORIGIN__HOSTNAME = domain;
          KELLNR_DOCS__ENABLED = "true";
        };
      };
    };
  };
  services.caddy.virtualHosts."${domain}".extraConfig = ''
    import auth
    reverse_proxy localhost:${toString port}
  '';
  services.authelia = {
    instances.darksailor = {
      settings = {
        access_control = {
          rules = [
            {
              inherit domain;
              policy = "one_factor";
            }
          ];
        };
      };
    };
  };
}
