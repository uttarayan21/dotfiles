{
  config,
  lib,
  pkgs,
  ...
}: {
  sops = {
    secrets = {
      "authelia/servers/darksailor/jwtSecret".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      "authelia/servers/darksailor/storageEncryptionSecret".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      "authelia/servers/darksailor/sessionSecret".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      "authelia/users/servius".owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      users.owner = config.systemd.services.authelia-darksailor.serviceConfig.User;
      "llama/api_key".owner = config.services.caddy.user;
    };
  };
  services = {
    home-assistant = {
      enable = true;
      extraComponents = [
        "esphome"
        "met"
        "radio_browser"
        "wiz"
        "google_assistant"
        "google_translate"
        # "auth_header"
      ];
      customComponents = [
        pkgs.home-assistant-custom-components.auth-header
      ];
      config = {
        default_config = {};
        http = {
          server_host = "::1";
          trusted_proxies = ["::1"];
          use_x_forwarded_for = true;
        };
        auth_header = {
          username_header = "Remote-User";
        };
      };
    };
    jellyfin = {
      enable = true;
    };
    authelia = {
      instances.darksailor = {
        enable = true;
        settings = {
          authentication_backend = {
            password_reset.disable = false;
            file = {
              path = "/run/secrets/users";
            };
          };
          session = {
            cookies = [
              {
                domain = "darksailor.dev";
                authelia_url = "https://auth.darksailor.dev";
                name = "authelia_session";
              }
            ];
          };
          access_control = {
            default_policy = "one_factor";
            rules = [
              {
                domain = "darksailor.dev";
                policy = "one_factor";
              }
            ];
          };
          storage = {
            local = {
              path = "/var/lib/authelia-darksailor/authelia.sqlite3";
            };
          };
          theme = "dark";
          notifier.filesystem.filename = "/var/lib/authelia-darksailor/authelia-notifier.log";
          server = {
            address = "127.0.0.1:5555";
            endpoints.authz.forward-auth = {
              implementation = "ForwardAuth";
            };
          };
          # log = {
          #   file_path = "/tmp/authelia.log";
          # };
        };
        secrets = {
          jwtSecretFile = config.sops.secrets."authelia/servers/darksailor/jwtSecret".path;
          storageEncryptionKeyFile = config.sops.secrets."authelia/servers/darksailor/storageEncryptionSecret".path;
          sessionSecretFile = config.sops.secrets."authelia/servers/darksailor/sessionSecret".path;
        };
      };
    };
    fail2ban = {
      enable = true;
      bantime = "24h"; # Ban IPs for one day on the first ban
      bantime-increment = {
        enable = true; # Enable increment of bantime after each violation
        # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h"; # Do not ban for more than 1 week
        overalljails = true; # Calculate the bantime based on all the violations
      };
      # jails.apache-nohome-iptables.settings = {
      #   # Block an IP address if it accesses a non-existent
      #   # home directory more than 5 times in 10 minutes,
      #   # since that indicates that it's scanning.
      #   filter = "apache-nohome";
      #   action = ''iptables-multiport[name=HTTP, port="http,https"]'';
      #   logpath = "/var/log/httpd/error_log*";
      #   backend = "auto";
      #   findtime = 600;
      #   bantime = 600;
      #   maxretry = 5;
      # };
    };
    tailscale = {
      enable = true;
    };
    navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/media/music";
      };
    };
    atuin = {
      enable = true;
    };
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      hostName = "cloud.darksailor.dev";
      config.adminuser = "servius";
      config.adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
      configureRedis = true;
      https = true;
    };
    llama-cpp = {
      enable = true;
      host = "127.0.0.1";
      port = 3000;
      model = builtins.fetchurl {
        name = "qwen_2.5.1_coder_7b_instruct_gguf";
        sha256 = "61834b88c1a1ce5c277028a98c4a0c94a564210290992a7ba301bbef96ef8eba";
        url = "https://huggingface.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF/resolve/main/Qwen2.5.1-Coder-7B-Instruct-Q8_0.gguf?download=true";
      };
      # extraFlags = ["--" "--in-prefix" "<|im_start|>" "--in-suffix" "<|im_end|>"];
      # model = builtins.fetchurl {
      #   name = "mistral-7b-claude-chat";
      #   sha256 = "03458d74d3e6ed650d67e7800492354e5a8a33aaaeabc80c484e28766814085a";
      #   url = "https://huggingface.co/TheBloke/Mistral-7B-Claude-Chat-GGUF/resolve/main/mistral-7b-claude-chat.Q8_0.gguf?download=true";
      # };
    };
    nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
      {
        addr = "127.0.0.1";
        port = 8080; # NOT an exposed port
      }
    ];

    caddy = {
      enable = true;
      virtualHosts."music.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:4533
      '';
      virtualHosts."atuin.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:8888
      '';
      virtualHosts."cloud.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:8080
      '';
      virtualHosts."llama.darksailor.dev".extraConfig = ''
        handle /api/v1/* {
            uri strip_prefix /api/v1
            reverse_proxy localhost:3000
        }

        handle {
            forward_auth localhost:5555 {
                uri /api/authz/forward-auth
                copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
            }
            reverse_proxy localhost:3000
        }
      '';
      virtualHosts."auth.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:5555
      '';
      virtualHosts."home.darksailor.dev".extraConfig = ''
        forward_auth localhost:5555 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
        }
        reverse_proxy localhost:8123

      '';
      virtualHosts."media.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:8096
      '';
    };
  };
}
