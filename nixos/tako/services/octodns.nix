{
  config,
  inputs,
  pkgs,
  ...
}: let
  generate = inputs.nixos-dns.utils.generate pkgs;
  dnsConfig = {
    inherit (inputs.self) nixosConfigurations;
    extraConfig = {};
  };
  octodnsConfigFile = generate.octodnsConfig {
    inherit dnsConfig;
    config = {
      providers = {
        # nixos-dns generates zone files without an NS RRset; tell the bind
        # source not to require one (Cloudflare manages NS records itself).
        config.check_origin = false;
        cloudflare = {
          class = "octodns_cloudflare.CloudflareProvider";
          token = "env/CLOUDFLARE_TOKEN";
          # Token is scoped to DNS only; skip pagerules (would 401).
          pagerules = false;
        };
      };
    };
    zones = {
      "darksailor.dev." = inputs.nixos-dns.utils.octodns.generateZoneAttrs ["cloudflare"];
    };
  };
  octodnsPkg = pkgs.octodns.withProviders (ps: [
    pkgs.octodns-providers.cloudflare
    pkgs.octodns-providers.bind
  ]);
  syncCmd = mode: "${octodnsPkg}/bin/octodns-sync --config-file ${octodnsConfigFile} ${mode}";
in {
  networking.domains.subDomains."lmstudio.shiro.darksailor.dev".a.data = inputs.self.devices.shiro.tailscaleIp;

  sops.secrets."cloudflare/cf_api_key" = {};

  sops.templates."octodns.env".content = ''
    CLOUDFLARE_TOKEN=${config.sops.placeholder."cloudflare/cf_api_key"}
  '';

  systemd.services.octodns-plan = {
    description = "OctoDNS drift detection (read-only)";
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = config.sops.templates."octodns.env".path;
      ExecStart = syncCmd "";
    };
  };

  systemd.services.octodns-apply = {
    description = "OctoDNS apply zone to Cloudflare";
    # Re-run on activation whenever the rendered zone changes (subdomain added,
    # removed, or modified anywhere in the flake).
    wantedBy = ["multi-user.target"];
    restartTriggers = [octodnsConfigFile];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      EnvironmentFile = config.sops.templates."octodns.env".path;
      ExecStart = syncCmd "--doit --force";
    };
  };

  # Enable once `networking.domains` declarations cover the real zone, otherwise
  # plan output is dominated by spurious deletes for unmodelled records.
  # systemd.timers.octodns-plan = {
  #   description = "Hourly OctoDNS drift detection";
  #   wantedBy = ["timers.target"];
  #   timerConfig = {
  #     OnCalendar = "hourly";
  #     Persistent = true;
  #   };
  # };
}
