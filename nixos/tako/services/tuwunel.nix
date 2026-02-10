{
  config,
  pkgs,
  ...
}: let
  port = 6167;
  base_domain = "darksailor.dev";
  client_id = "tuwunel";
  elementConfig = builtins.toJSON {
    default_server_config = {
      "m.homeserver" = {
        base_url = "https://matrix.${base_domain}";
      };
    };
    sso_redirect_options = {
      # immediate = false;
      # on_welcome_page = true;
      # on_login_page = true;
    };
  };
  elementConfigFile = pkgs.writeText "element-config.json" elementConfig;
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
    };
    package = pkgs.matrix-tuwunel;
  };
  services.caddy.virtualHosts."matrix.${base_domain}, matrix.${base_domain}:8448".extraConfig = ''
    reverse_proxy /_matrix/* localhost:${toString port}
    handle_path /config.json {
        root ${elementConfigFile}
        file_server
    }
    root * ${pkgs.element-web}
    file_server
  '';

  users.users.${config.services.caddy.user}.extraGroups = [config.services.matrix-tuwunel.group];

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
                    # "https://auth.${base_domain}/user/oauth2/authelia/callback"
                    "https://matrix.${base_domain}/_matrix/client/v3/login/sso/redirect/${client_id}"
                  ];
                  scopes = [
                    "email"
                    "name"
                    "groups"
                    "preferred_username"
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
# templates = {
#   "tuwunel-auth.toml" = {
#     content = ''
#       [[global.identity_provider]]
#       brand = "Authelia"
#       name = "Authelia"
#       default = true
#       issuer_url = "https://auth.${base_domain}"
#       client_id = "${config.sops.placeholder."tuwunel/client_id"}"
#       client_secret = "${config.sops.placeholder."tuwunel/client_secret"}"
#       callback_url = "https://matrix.${base_domain}/_matrix/client/v3/login/sso/redirect/${config.sops.placeholder."tuwunel/client_id"}"
#     '';
#     # callback_url = "https://auth.${base_domain}/_matrix/client/unstable/login/sso/callback/${config.sops.placeholder."tuwunel/client_id"}"
#     owner = config.services.matrix-tuwunel.user;
#     group = config.services.matrix-tuwunel.group;
#   };
# };
# extraEnvironment = {
#   CONDUIT_CONFIG = config.sops.templates."tuwunel-auth.toml".path;
# };

