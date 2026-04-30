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
      providers.cloudflare = {
        class = "octodns_cloudflare.CloudflareProvider";
        cf_token = "env/CLOUDFLARE_TOKEN";
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
  sops.secrets."cloudflare/darksailor_dev_api_key" = {};

  sops.templates."octodns.env".content = ''
    CLOUDFLARE_TOKEN=${config.sops.placeholder."cloudflare/darksailor_dev_api_key"}
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
    serviceConfig = {
      Type = "oneshot";
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
