{...}: {
  services = {
    homepage-dashboard = {
      enable = true;
      allowedHosts = "dashboard.darksailor.dev";
      settings = {
        title = "Servius' Dashboard";
        description = "A collection of services and links for quick access.";
      };
      widgets = [
        {
          resources = {
            cpu = true;
            disk = "/";
            memory = true;
          };
        }
      ];
      services = [
        {
          "Tsuba" = [
            {
              "Jellyfin" = {
                description = "Jellyfin Media Server";
                href = "https://jellyfin.tsuba.darksailor.dev";
              };
            }
            {
              "Sonarr" = {
                description = "Sonarr";
                href = "https://sonarr.tsuba.darksailor.dev";
              };
            }
            {
              "Radarr" = {
                description = "Radarr";
                href = "https://radarr.tsuba.darksailor.dev";
              };
            }
            {
              "Deluge" = {
                description = "Deluge";
                href = "https://deluge.tsuba.darksailor.dev";
              };
            }
            {
              "Prowlarr" = {
                description = "Prowlarr";
                href = "https://prowlarr.tsuba.darksailor.dev";
              };
            }
            {
              "Home Assistant" = {
                description = "Home Automation";
                href = "https://home.darksailor.dev";
              };
            }
          ];
        }
        {
          "Mirai" = [
            {
              "Gitea" = {
                description = "Gitea Code Hosting";
                href = "https://git.darksailor.dev";
              };
            }
            {
              "Nextcloud" = {
                description = "Nextcloud Suite";
                href = "https://cloud.darksailor.dev";
              };
            }
            {
              "Open WebUI" = {
                description = "Open WebUI for self hosted llms";
                href = "https://llama.darksailor.dev";
              };
            }
          ];
        }
      ];
    };
    caddy = {
      virtualHosts."dashboard.darksailor.dev".extraConfig = ''
        forward_auth localhost:5555 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
        }
        reverse_proxy localhost:8082
      '';
    };
  };
}
