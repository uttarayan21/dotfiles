{
  config,
  lib,
  pkgs,
  device,
  ...
}:
with lib; let
  serverOptions = {
    enable = mkEnableOption "server";

    domain = mkOption {
      type = types.str;
      description = "Public domain for this server (e.g. jellyfin.darksailor.dev)";
    };

    externalHost = mkOption {
      type = types.str;
      description = "Public or Tailscale IP for DNS record (used by cfcli)";
    };

    port = mkOption {
      type = types.port;
      description = "Port caddy proxies to.";
    };

    enableDashboard = mkOption {
      type = types.bool;
      default = true;
      description = "Add this server to homepage-dashboard";
    };

    enableAuth = mkOption {
      type = types.bool;
      default = false;
      description = "Enable auth for this server";
    };

    authMethod = mkOption {
      type = types.enum ["forwardAuth" "oidc"];
      default = "forwardAuth";
      description = ''
        Auth method: forwardAuth uses caddy's import auth snippet,
        oidc is handled by the service natively.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "";
      description = "Dashboard group name (e.g. Tsuba, Tako). Defaults to device name.";
    };

    icon = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Dashboard icon filename (e.g. jellyfin.png)";
    };

    description = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Dashboard description";
    };

    caddyExtraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra caddy config. When useDefaultProxy is true, appended after reverse_proxy. When false, used as the full extraConfig.";
    };

    useDefaultProxy = mkOption {
      type = types.bool;
      default = true;
      description = "Generate the default reverse_proxy and auth config. Set to false to use caddyExtraConfig as the full virtualHost config.";
    };

    caddySnippet = mkOption {
      type = types.lines;
      default = "";
      description = "Caddy snippet to include at the start of the virtual host (e.g. import cloudflare)";
    };

    enableDns = mkOption {
      type = types.bool;
      default = true;
      description = "Create a DNS record via cfcli pointing to externalHost";
    };

    dnsType = mkOption {
      type = types.enum ["A" "CNAME"];
      default = "A";
      description = "DNS record type";
    };
  };

  enabledServers = filterAttrs (_: cfg: cfg.enable) config.servers;

  resolveGroup = cfg:
    if cfg.group != ""
    then cfg.group
    else device.name;

  dashboardServers = filterAttrs (_: cfg: cfg.enable && cfg.enableDashboard) config.servers;

  dashboardGrouped =
    foldl' (
      acc: name: let
        cfg = dashboardServers.${name};
        group = resolveGroup cfg;
      in
        acc
        // {
          ${group} =
            (acc.${group} or [])
            ++ [{inherit name cfg;}];
        }
    ) {}
    (attrNames dashboardServers);

  dashboardEntries =
    map (group: {
      ${group} =
        map (entry: {
          ${entry.name} =
            {
              href = "https://${entry.cfg.domain}";
              siteMonitor = "https://${entry.cfg.domain}";
            }
            // optionalAttrs (entry.cfg.icon != null) {
              icon = entry.cfg.icon;
            }
            // optionalAttrs (entry.cfg.description != null) {
              description = entry.cfg.description;
            };
        })
        dashboardGrouped.${group};
    })
    (attrNames dashboardGrouped);

  forwardAuthServers = filterAttrs (_: cfg:
    cfg.enable && cfg.enableAuth && cfg.authMethod == "forwardAuth")
  config.servers;
in {
  imports = [
    ./atuin.nix
    ./bazarr.nix
    ./deluge.nix
    ./excalidraw.nix
    ./gitea.nix
    ./grafana.nix
    ./homeassistant.nix
    ./immich.nix
    ./jellyfin.nix
    ./kellnr.nix
    ./navidrome.nix
    ./nextcloud.nix
    ./openwebui.nix
    ./pihole.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./vaultwarden.nix
  ];

  options.servers = mkOption {
    type = types.attrsOf (types.submodule {options = serverOptions;});
    default = {};
    description = "Declarative server configurations with automatic caddy, DNS, dashboard, and auth integration";
  };

  config = mkIf (enabledServers != {}) {
    services.caddy.virtualHosts = mapAttrs' (_: cfg: let
      portPart = ":${toString cfg.port}";
      authSnippet =
        if cfg.enableAuth && cfg.authMethod == "forwardAuth"
        then "import auth\n"
        else "";
      defaultConfig = ''
        ${cfg.caddySnippet}
        ${authSnippet}
        reverse_proxy localhost${portPart}
        ${cfg.caddyExtraConfig}
      '';
    in
      nameValuePair cfg.domain {
        extraConfig =
          if cfg.useDefaultProxy
          then defaultConfig
          else cfg.caddyExtraConfig;
      })
    enabledServers;

    services.homepage-dashboard.services = dashboardEntries;

    services.authelia.instances.darksailor.settings.access_control.rules =
      map (_: cfg: {
        domain = cfg.domain;
        policy = "one_factor";
      })
      (attrValues forwardAuthServers);

    sops.secrets."cloudflare/darksailor_dev_api_key" = mkDefault {};

    systemd.services = mapAttrs' (name: cfg:
      nameValuePair "cfcli-${name}" {
        description = "DNS A record for ${cfg.domain} → ${cfg.externalHost}";
        wantedBy = ["multi-user.target"];
        after = ["network.target" "sops-install-secrets.service"];
        requires = ["sops-install-secrets.service"];
        path = [pkgs.cloudflare-cli];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          EnvironmentFile = config.sops.templates."CLOUDFLARE_API_KEY.env".path;
        };
        script = ''
          cfcli -k "$CF_API_KEY" add --type ${cfg.dnsType} -a ${cfg.domain} ${cfg.externalHost} 2>/dev/null || \
            cfcli -k "$CF_API_KEY" edit ${cfg.domain} ${cfg.externalHost}
        '';
      })
    (filterAttrs (_: cfg: cfg.enable && cfg.enableDns) config.servers);

    sops.templates."CLOUDFLARE_API_KEY.env".content = ''
      CF_API_KEY=${config.sops.placeholder."cloudflare/darksailor_dev_api_key"}
    '';
  };
}
