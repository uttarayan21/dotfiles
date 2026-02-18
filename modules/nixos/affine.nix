{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.affine;
  dbName = "affine";
  dbUser = "affine";
in {
  options.services.affine = {
    enable = mkEnableOption "AFFiNE self-hosted workspace";

    port = mkOption {
      type = types.port;
      default = 3010;
      description = "Port for the AFFiNE server to listen on";
    };

    domain = mkOption {
      type = types.str;
      description = "Public domain for AFFiNE (e.g. notes.darksailor.dev)";
    };

    imageTag = mkOption {
      type = types.str;
      default = "stable";
      description = "Docker image tag for AFFiNE (stable, beta, canary)";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/affine";
      description = "Base data directory for AFFiNE storage";
    };

    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [];
      description = "Environment files containing secrets (DB password, etc.)";
    };
  };

  config = mkIf cfg.enable {
    # Create data directories
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 root root -"
      "d ${cfg.dataDir}/storage 0755 root root -"
      "d ${cfg.dataDir}/config 0755 root root -"
      "d ${cfg.dataDir}/postgres 0700 root root -"
      "d ${cfg.dataDir}/redis 0755 root root -"
    ];

    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        affine-postgres = {
          image = "pgvector/pgvector:pg16";
          volumes = [
            "${cfg.dataDir}/postgres:/var/lib/postgresql/data"
          ];
          environment = {
            POSTGRES_USER = dbUser;
            POSTGRES_DB = dbName;
            POSTGRES_INITDB_ARGS = "--data-checksums";
            POSTGRES_HOST_AUTH_METHOD = "trust";
          };
          environmentFiles = cfg.environmentFiles;
          extraOptions = [
            "--network=affine-net"
            "--health-cmd=pg_isready -U ${dbUser} -d ${dbName}"
            "--health-interval=10s"
            "--health-timeout=5s"
            "--health-retries=5"
          ];
        };

        affine-redis = {
          image = "redis:7";
          volumes = [
            "${cfg.dataDir}/redis:/data"
          ];
          extraOptions = [
            "--network=affine-net"
            "--health-cmd=redis-cli --raw incr ping"
            "--health-interval=10s"
            "--health-timeout=5s"
            "--health-retries=5"
          ];
        };

        affine = {
          image = "ghcr.io/toeverything/affine:${cfg.imageTag}";
          ports = ["127.0.0.1:${toString cfg.port}:3010"];
          dependsOn = [
            "affine-postgres"
            "affine-redis"
            "affine-migration"
          ];
          volumes = [
            "${cfg.dataDir}/storage:/root/.affine/storage"
            "${cfg.dataDir}/config:/root/.affine/config"
          ];
          environment = {
            AFFINE_SERVER_PORT = "3010";
            AFFINE_SERVER_HOST = cfg.domain;
            AFFINE_SERVER_HTTPS = "true";
            AFFINE_SERVER_EXTERNAL_URL = "https://${cfg.domain}";
            REDIS_SERVER_HOST = "affine-redis";
            DATABASE_URL = "postgresql://${dbUser}:$${AFFINE_DB_PASSWORD:-affine}@affine-postgres:5432/${dbName}";
            AFFINE_INDEXER_ENABLED = "false";
          };
          environmentFiles = cfg.environmentFiles;
          extraOptions = [
            "--network=affine-net"
          ];
        };

        affine-migration = {
          image = "ghcr.io/toeverything/affine:${cfg.imageTag}";
          dependsOn = [
            "affine-postgres"
            "affine-redis"
          ];
          volumes = [
            "${cfg.dataDir}/storage:/root/.affine/storage"
            "${cfg.dataDir}/config:/root/.affine/config"
          ];
          cmd = ["sh" "-c" "node ./scripts/self-host-predeploy.js"];
          environment = {
            REDIS_SERVER_HOST = "affine-redis";
            DATABASE_URL = "postgresql://${dbUser}:$${AFFINE_DB_PASSWORD:-affine}@affine-postgres:5432/${dbName}";
            AFFINE_INDEXER_ENABLED = "false";
          };
          environmentFiles = cfg.environmentFiles;
          extraOptions = [
            "--network=affine-net"
          ];
        };
      };
    };

    # Create the Docker network
    systemd.services.affine-network = {
      description = "Create AFFiNE Docker network";
      after = ["docker.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${config.virtualisation.docker.package}/bin/docker network create affine-net";
        ExecStop = "${config.virtualisation.docker.package}/bin/docker network remove affine-net";
      };
    };

    # Ensure containers start after the network is created
    systemd.services.docker-affine.after = ["affine-network.service"];
    systemd.services.docker-affine.requires = ["affine-network.service"];
    systemd.services.docker-affine-postgres.after = ["affine-network.service"];
    systemd.services.docker-affine-postgres.requires = ["affine-network.service"];
    systemd.services.docker-affine-redis.after = ["affine-network.service"];
    systemd.services.docker-affine-redis.requires = ["affine-network.service"];
    systemd.services.docker-affine-migration.after = ["affine-network.service"];
    systemd.services.docker-affine-migration.requires = ["affine-network.service"];
  };
}
