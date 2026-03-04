{
  config,
  inputs,
  pkgs,
  ...
}: {
  services.tangled.knot = {
    enable = true;
    package = inputs.tangled-core.packages.${pkgs.system}.knot;
    server = {
      hostname = "tangled.darksailor.dev";
      owner = "did:plc:tllyvpa5oxw6fwwhkj3kv6dr";
      listenAddr = "127.0.0.1:5969";
    };
  };

  services.caddy.virtualHosts."tangled.darksailor.dev".extraConfig = ''
    reverse_proxy ${config.services.tangled.knot.server.listenAddr} {
        header_up Host {host}
        header_up X-Real-IP {remote}
        header_up X-Forwarded-For {remote}
        header_up X-Forwarded-Proto {scheme}
    }
    handle /events/* {
        reverse_proxy ${config.services.tangled.knot.server.listenAddr} {
            header_up X-Forwarded-For {remote}
            header_up Host {host}
        }
    }
  '';
}
