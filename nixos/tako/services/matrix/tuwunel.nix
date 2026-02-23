{
  config,
  pkgs,
  lib,
  ...
}: let
  port = 6167;
  base_domain = "darksailor.dev";
  client_id = "tuwunel";
  rtc_domain = "matrix-rtc.${base_domain}";
  livekit_port = 7880;
  livekit_rtc_tcp_port = 7881;
  livekit_rtc_port_start = 50100;
  livekit_rtc_port_end = 50200;
  livekit_turn_udp_port = 3478;
  livekit_turn_relay_start = 50300;
  livekit_turn_relay_end = 65535;
  jwt_port = 8081;
  elementConfig = builtins.toJSON {
    default_server_config = {
      "m.homeserver" = {
        base_url = "https://matrix.${base_domain}";
      };
    };
    sso_redirect_options = {
      immediate = false;
      on_welcome_page = true;
      on_login_page = true;
    };
  };
  elementConfigFile = pkgs.writeText "element-config.json" elementConfig;
  livekitConfigTemplate = pkgs.writeText "livekit.yaml.template" ''
    port: ${toString livekit_port}
    bind_addresses:
      - ""
    rtc:
      tcp_port: ${toString livekit_rtc_tcp_port}
      port_range_start: ${toString livekit_rtc_port_start}
      port_range_end: ${toString livekit_rtc_port_end}
      use_external_ip: true
      enable_loopback_candidate: false
    keys:
      LIVEKIT_KEY_PLACEHOLDER: LIVEKIT_SECRET_PLACEHOLDER
    turn:
      enabled: true
      udp_port: ${toString livekit_turn_udp_port}
      relay_range_start: ${toString livekit_turn_relay_start}
      relay_range_end: ${toString livekit_turn_relay_end}
      domain: ${rtc_domain}
  '';
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
      reverse_proxy /_matrix/* localhost:${toString port}
      handle_path /config.json  {
        file_server
        root ${elementConfigFile}
      }
      root * ${pkgs.element-web}
      file_server
    '';
    "${base_domain}".extraConfig = ''
      reverse_proxy /.well-known/* localhost:${toString port}
    '';
    # "matrix.${base_domain}:8448".extraConfig = ''
    #   reverse_proxy /_matrix/* localhost:${toString port}
    # '';
    "${rtc_domain}".extraConfig = ''
      @jwt_service {
        path /sfu/get* /healthz*
      }
      handle @jwt_service {
        reverse_proxy localhost:${toString jwt_port}
      }
      handle {
        reverse_proxy localhost:${toString livekit_port} {
          header_up Connection "upgrade"
          header_up Upgrade {http.request.header.Upgrade}
        }
      }
    '';
  };
  networking.firewall = {
    allowedTCPPorts = [8448 livekit_rtc_tcp_port];
    allowedUDPPorts = [livekit_turn_udp_port];
    allowedUDPPortRanges = [
      {
        from = livekit_rtc_port_start;
        to = livekit_rtc_port_end;
      }
      {
        from = livekit_turn_relay_start;
        to = livekit_turn_relay_end;
      }
    ];
  };

  users.users.${config.services.caddy.user}.extraGroups = [config.services.matrix-tuwunel.group];

  # LiveKit server
  systemd.services.livekit = {
    description = "LiveKit SFU server";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      DynamicUser = true;
      StateDirectory = "livekit";
      RuntimeDirectory = "livekit";
      ExecStartPre = let
        script = pkgs.writeShellScript "livekit-config" ''
          KEY_NAME=$(cat ${config.sops.secrets."livekit/key_name".path})
          KEY_SECRET=$(cat ${config.sops.secrets."livekit/key_secret".path})
          ${lib.getExe pkgs.gnused} \
            -e "s|LIVEKIT_KEY_PLACEHOLDER|$KEY_NAME|g" \
            -e "s|LIVEKIT_SECRET_PLACEHOLDER|$KEY_SECRET|g" \
            ${livekitConfigTemplate} > /run/livekit/livekit.yaml
        '';
      in "${script}";
      ExecStart = "${lib.getExe pkgs.livekit} --config /run/livekit/livekit.yaml";
      Restart = "on-failure";
      RestartSec = 5;
      AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
    };
  };

  # LiveKit JWT service for MatrixRTC
  systemd.services.lk-jwt-service = {
    description = "LiveKit JWT service for MatrixRTC";
    after = ["network-online.target" "livekit.service"];
    wants = ["network-online.target"];
    requires = ["livekit.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${lib.getExe pkgs.lk-jwt-service}";
      Restart = "on-failure";
      RestartSec = 5;
    };
    environment = {
      LIVEKIT_JWT_BIND = ":${toString jwt_port}";
      LIVEKIT_URL = "wss://${rtc_domain}";
      LIVEKIT_KEY_FILE = config.sops.secrets."livekit/key_name".path;
      LIVEKIT_SECRET_FILE = config.sops.secrets."livekit/key_secret".path;
      LIVEKIT_FULL_ACCESS_HOMESERVERS = base_domain;
    };
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
