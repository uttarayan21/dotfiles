# docker run --rm -it \
# -p 8000:8000 \
# -e "KELLNR_ORIGIN__HOSTNAME=kellnr.example.com" \
# -v $(pwd):/opt/kdata ghcr.io/kellnr/kellnr:5
# E.g. docker run -v /path/to/config.toml:/usr/local/cargo/config.toml:ro ghcr.io/kellnr/kellnr:5.2.4
{config, ...}: let
  port = 8899;
  domain = "crates.darksailor.dev";
in {
  sops = {
    secrets."kellnr/password" = {};
    secrets."kellnr/token" = {};
    templates."kellnr.env".content = ''
      KELLNR_SETUP__ADMIN_PWD=${config.sops.placeholder."kellnr/password"}
      KELLNR_SETUP__ADMIN_TOKEN=${config.sops.placeholder."kellnr/token"}
    '';
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
          KELLNR_ORIGIN__PROTOCOL = "https";
          KELLNR_ORIGIN__PORT = "443";
        };
        environmentFiles = [
          config.sops.templates."kellnr.env".path
        ];
      };
    };
  };
  services.caddy.virtualHosts."${domain}".extraConfig = ''
    # import auth
    reverse_proxy localhost:${toString port}
  '';
  # services.authelia = {
  #   instances.darksailor = {
  #     settings = {
  #       access_control = {
  #         rules = [
  #           {
  #             inherit domain;
  #             policy = "one_factor";
  #           }
  #         ];
  #       };
  #     };
  #   };
  # };
}
