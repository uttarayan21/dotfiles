{
  config,
  pkgs,
  ...
}: let
  port = 6167;
  base_domain = "darksailor.dev";
  client_id = "tuwunel";
  rtc_domain = "matrix-rtc.${base_domain}";
  jwt_port = 8081;
  cinnyConfig = builtins.toJSON {
    defaultHomeserver = 0;
    homeserverList = ["darksailor.dev" "matrix.org"];
    allowCustomHomeservers = false;
    hashRouter = {
      enabled = true;
      basename = "/";
    };
  };
  cinnyConfigFile = pkgs.writeText "cinny-config.json" cinnyConfig;
in {
  sops = {
    secrets."tuwunel/client_id" = {
      owner = config.services.matrix-tuwunel.user;
      group = config.systemd.services.authelia-darksailor.serviceConfig.Group;
      mode = "0440";
    };
    secrets."tuwunel/client_secret" = {
      owner = config.services.matrix-tuwunel.user;
      group = config.systemd.services.authelia-darksailor.serviceConfig.Group;
      mode = "0440";
    };
    secrets."tuwunel/registration_token".owner = config.services.matrix-tuwunel.user;
    secrets."livekit/key_name" = {};
    secrets."livekit/key_secret" = {};
    templates."livekit-keys".content = ''
      ${config.sops.placeholder."livekit/key_name"}: ${config.sops.placeholder."livekit/key_secret"}
    '';
  };
  services.matrix-tuwunel = {
    enable = true;
    settings.global = {
      server_name = "${base_domain}";
      address = ["127.0.0.1"];
      port = [port];
      allow_registration = true;
      registration_token_file = config.sops.secrets."tuwunel/registration_token".path;
      single_sso = true;
      identity_provider = [
        {
          inherit client_id;
          brand = "Authelia";
          name = "Authelia";
          default = true;
          issuer_url = "https://auth.${base_domain}";
          client_secret_file = config.sops.secrets."tuwunel/client_secret".path;
          callback_url = "https://matrix.${base_domain}/_matrix/client/unstable/login/sso/callback/${client_id}";
        }
      ];
      well_known = {
        client = "https://matrix.${base_domain}";
        server = "matrix.${base_domain}:443";
        rtc_transports = [
          {
            type = "livekit";
            livekit_service_url = "https://${rtc_domain}";
          }
        ];
      };
    };
    package = pkgs.matrix-tuwunel;
  };
  services.caddy.virtualHosts = {
    "matrix.${base_domain}".extraConfig = ''
      handle /_matrix/* {
        reverse_proxy /_matrix/* localhost:${toString port}
      }
      handle_path /config.json  {
        file_server
        root ${cinnyConfigFile}
      }
      handle {
          root * ${pkgs.cinny}
          try_files {path} /index.html
          file_server
      }
    '';
    "${base_domain}".extraConfig = ''
      reverse_proxy /.well-known/* localhost:${toString port}
    '';
    "${rtc_domain}".extraConfig = ''
      @jwt_service {
        path /sfu/get* /healthz*
      }
      handle @jwt_service {
        reverse_proxy localhost:${toString jwt_port}
      }
      handle {
        reverse_proxy localhost:${toString config.services.livekit.settings.port} {
          header_up Connection "upgrade"
          header_up Upgrade {http.request.header.Upgrade}
        }
      }
    '';
  };
  networking.firewall = {
    allowedTCPPorts = [8448 7881];
    allowedUDPPorts = [3478];
    allowedUDPPortRanges = [
      {
        from = 50300;
        to = 65535;
      }
    ];
  };

  users.users.${config.services.caddy.user}.extraGroups = [config.services.matrix-tuwunel.group];

  services.livekit = {
    enable = true;
    keyFile = config.sops.templates."livekit-keys".path;
    openFirewall = true;
    settings = {
      rtc = {
        tcp_port = 7881;
        port_range_start = 50100;
        port_range_end = 50200;
        use_external_ip = true;
        enable_loopback_candidate = false;
      };
      turn = {
        enabled = true;
        udp_port = 3478;
        relay_range_start = 50300;
        relay_range_end = 65535;
        domain = rtc_domain;
      };
    };
  };

  services.lk-jwt-service = {
    enable = true;
    port = jwt_port;
    livekitUrl = "wss://${rtc_domain}";
    keyFile = config.sops.templates."livekit-keys".path;
  };

  services = {
    authelia = {
      instances.darksailor = {
        settings = {
          identity_providers = {
            oidc = {
              claims_policies = {
                tuwunel = {
                  id_token = [
                    "email"
                    "name"
                    "groups"
                    "preferred_username"
                  ];
                };
              };
              clients = [
                {
                  inherit client_id;
                  client_name = "Matrix: Darksailor";
                  client_secret = ''{{ secret "${config.sops.secrets."tuwunel/client_secret".path}" }}'';
                  public = false;
                  authorization_policy = "one_factor";
                  require_pkce = false;
                  # pkce_challenge_method = "S256";
                  redirect_uris = [
                    "https://matrix.${base_domain}/_matrix/client/unstable/login/sso/callback/${client_id}"
                  ];
                  scopes = [
                    "openid"
                    "groups"
                    "email"
                    "profile"
                  ];
                  response_types = ["code"];
                  response_modes = ["form_post"];
                  grant_types = ["refresh_token" "authorization_code"];
                  userinfo_signed_response_alg = "none";
                  token_endpoint_auth_method = "client_secret_post";
                }
              ];
            };
          };
        };
      };
    };
  };
}
