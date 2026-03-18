{config, ...}: let
  base_domain = "darksailor.dev";
in {
  sops = {
    # secrets."nextcloud/adminpass".owner = config.users.users.caddy.name;
    secrets."mautrix-signal/pickle_key".owner = config.users.users.mautrix-signal.name;
    secrets."mautrix-signal/as_token".owner = config.users.users.mautrix-signal.name;
    secrets."mautrix-signal/hs_token".owner = config.users.users.mautrix-signal.name;
  };
  sops.templates = {
    "mautrix-signal.env" = {
      content = ''
        ENCRYPTION_PICKLE_KEY=${config.sops.placeholder."mautrix-signal/pickle_key"}
        MAUTRIX_SIGNAL_APPSERVICE_AS_TOKEN=${config.sops.placeholder."mautrix-signal/as_token"}
        MAUTRIX_SIGNAL_APPSERVICE_HS_TOKEN=${config.sops.placeholder."mautrix-signal/hs_token"}
      '';
      owner = config.users.users.mautrix-signal.name;
      group = config.users.groups.mautrix-signal.name;
    };
    "tuwunel-signal.env" = {
      content = ''
        TUWUNEL_APPSERVICE__SIGNAL__AS_TOKEN=${config.sops.placeholder."mautrix-signal/as_token"}
        TUWUNEL_APPSERVICE__SIGNAL__HS_TOKEN=${config.sops.placeholder."mautrix-signal/hs_token"}
      '';
      owner = config.users.users.matrix-tuwunel.name;
      group = config.users.groups.matrix-tuwunel.name;
    };
  };
  systemd.services.tuwunel.serviceConfig.EnvironmentFile = config.sops.templates."tuwunel-signal.env".path;

  services.mautrix-signal = {
    enable = true;
    registerToSynapse = false;
    serviceDependencies = ["tuwunel.service"];
    environmentFile = config.sops.templates."mautrix-signal.env".path;
    settings = {
      homeserver = {
        address = "http://localhost:6167";
        domain = base_domain;
      };
      bridge = {
        permissions = {
          "${base_domain}" = "user";
          "@servius:${base_domain}" = "admin";
        };
      };
      appservice = {
        sender_localpart = "signalbot";
        as_token = "$MAUTRIX_SIGNAL_APPSERVICE_AS_TOKEN";
        hs_token = "$MAUTRIX_SIGNAL_APPSERVICE_HS_TOKEN";
      };
      encryption = {
        allow = true;
        default = true;
        require = true;
        pickle_key = "$ENCRYPTION_PICKLE_KEY";
      };
    };
  };

  services.matrix-tuwunel = {
    settings.global = {
      appservice.signal = {
        url = "http://localhost:29328";
        sender_localpart = "signalbot";
        rate_limited = false;
        receive_ephemeral = true;
        users = [
          {
            exclusive = true;
            regex = "@signal_.*:${base_domain}";
          }
          {
            exclusive = true;
            regex = "@signalbot:${base_domain}";
          }
        ];
      };
    };
    extraEnvironment = {
      TUWUNEL_APPSERVICE__SIGNAL__URL = "http://localhost:29328";
      TUWUNEL_APPSERVICE__SIGNAL__SENDER_LOCALPART = "signalbot";
    };
  };
}
