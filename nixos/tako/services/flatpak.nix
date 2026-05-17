{
  config,
  pkgs,
  lib,
  ...
}: let
  stateDir = "/var/lib/flat-manager";
  repoBase = "${stateDir}/repos";
  buildRepoBase = "${stateDir}/build-repos";
  gpgHome = "${stateDir}/.gnupg";
  signFingerprint = "E905BC5545AB37A8C0FBE2AB5FBDDDB5F4E40BBA";
  dbName = "flat-manager";
  dbUser = "flat-manager";
  port = 8062;
  gpg2Shim = pkgs.writeShellScriptBin "gpg2" ''exec ${pkgs.gnupg}/bin/gpg "$@"'';

  configTemplate = {
    repos.stable = {
      path = "${repoBase}/stable";
      suggested-repo-name = "darksailor";
      runtime-repo-url = "https://flathub.org/repo/flathub.flatpakrepo";
      gpg-key = signFingerprint;
      subsets = {};
    };
    port = port;
    delay-update-secs = 10;
    database-url = "postgres:///${dbName}?host=/run/postgresql";
    build-repo-base = buildRepoBase;
    build-gpg-key = signFingerprint;
    gpg-homedir = gpgHome;
  };
in {
  networking.domains.subDomains."flatpak.darksailor.dev" = {};

  sops.secrets."flatpak/signing_key_ascii" = {
    owner = dbUser;
    mode = "0400";
  };
  sops.secrets."flat-manager/jwt_secret_b64" = {
    owner = dbUser;
    mode = "0400";
    restartUnits = ["flat-manager.service"];
  };
  sops.templates."flat-manager-config.json" = {
    owner = dbUser;
    mode = "0400";
    restartUnits = ["flat-manager.service"];
    content = builtins.toJSON (configTemplate
      // {
        secret = config.sops.placeholder."flat-manager/jwt_secret_b64";
      });
  };

  users.users.${dbUser} = {
    isSystemUser = true;
    group = dbUser;
    home = stateDir;
    createHome = false;
  };
  users.groups.${dbUser} = {};

  systemd.tmpfiles.rules = [
    "d ${stateDir}     0750 ${dbUser} ${dbUser} - -"
    "d ${repoBase}     0755 ${dbUser} ${dbUser} - -"
    "d ${buildRepoBase} 0755 ${dbUser} ${dbUser} - -"
    "d ${gpgHome}      0700 ${dbUser} ${dbUser} - -"
  ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [dbName];
    ensureUsers = [
      {
        name = dbUser;
        ensureDBOwnership = true;
      }
    ];
  };

  services.caddy.virtualHosts."flatpak.darksailor.dev".extraConfig = ''
    reverse_proxy localhost:${toString port}
  '';

  systemd.services.flat-manager-bootstrap = {
    description = "Import flat-manager signing key + init published OSTree repos";
    after = ["sops-install-secrets.service"];
    wants = ["sops-install-secrets.service"];
    before = ["flat-manager.service"];
    wantedBy = ["multi-user.target"];
    path = with pkgs; [gnupg ostree coreutils];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = dbUser;
      Group = dbUser;
    };
    environment.GNUPGHOME = gpgHome;
    script = ''
      set -euo pipefail
      if ! gpg --list-secret-keys ${signFingerprint} >/dev/null 2>&1; then
        gpg --batch --import ${config.sops.secrets."flatpak/signing_key_ascii".path}
      fi
      gpg --export ${signFingerprint} > ${stateDir}/flatpak-pub.gpg

      for repo in stable; do
        repo_path=${repoBase}/$repo
        if [ ! -f "$repo_path/config" ]; then
          mkdir -p "$repo_path"
          ostree --repo="$repo_path" init --mode=archive-z2
          ostree --repo="$repo_path" config set core.min-free-space-percent 0
        fi
      done
    '';
  };

  systemd.services.flat-manager = {
    description = "Flat-manager: flatpak repo HTTP API + OSTree publisher";
    after = ["postgresql.service" "flat-manager-bootstrap.service" "network-online.target"];
    requires = ["postgresql.service" "flat-manager-bootstrap.service"];
    wantedBy = ["multi-user.target"];
    path = [gpg2Shim] ++ (with pkgs; [ostree flatpak gnupg]);
    environment = {
      REPO_CONFIG = config.sops.templates."flat-manager-config.json".path;
      GNUPGHOME = gpgHome;
      RUST_LOG = "info";
    };
    serviceConfig = {
      Type = "simple";
      User = dbUser;
      Group = dbUser;
      WorkingDirectory = stateDir;
      ExecStart = "${lib.getExe pkgs.flat-manager}";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  environment.systemPackages = [pkgs.flat-manager];
}
