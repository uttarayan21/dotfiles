{config, ...}: {
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
                icon = "jellyfin.png";
                description = "Jellyfin Media Server";
                href = "https://jellyfin.tsuba.darksailor.dev";
                ping = "jellyfin.tsuba.darksailor.dev";
              };
            }
            {
              "Sonarr" = {
                icon = "sonarr.png";
                description = "Sonarr: TV Series Management";
                href = "https://sonarr.tsuba.darksailor.dev";
                ping = "sonarr.tsuba.darksailor.dev";
              };
            }
            {
              "Bazarr" = {
                icon = "bazarr.png";
                description = "Bazarr: Subtitles and Metadata";
                href = "https://bazarr.tsuba.darksailor.dev";
                ping = "bazarr.tsuba.darksailor.dev";
              };
            }
            {
              "Radarr" = {
                icon = "radarr.png";
                description = "Radarr: Movie Management";
                href = "https://radarr.tsuba.darksailor.dev";
                ping = "radarr.tsuba.darksailor.dev";
              };
            }
            {
              "Deluge" = {
                icon = "deluge.png";
                description = "Deluge: Torrent Client";
                href = "https://deluge.tsuba.darksailor.dev";
                ping = "deluge.tsuba.darksailor.dev";
              };
            }
            {
              "Prowlarr" = {
                icon = "prowlarr.png";
                description = "Prowlarr: Indexer Manager";
                href = "https://prowlarr.darksailor.dev";
                ping = "prowlarr.darksailor.dev";
              };
            }
            {
              "Home Assistant" = {
                icon = "home-assistant.png";
                description = "Home Automation";
                href = "https://home.darksailor.dev";
                ping = "home.darksailor.dev";
              };
            }
          ];
        }
        {
          "Tako" = [
            {
              "Gitea" = {
                icon = "gitea.png";
                description = "Gitea Code Hosting";
                href = "https://git.darksailor.dev";
                ping = "git.darksailor.dev";
              };
            }
            {
              "Nextcloud" = {
                icon = "nextcloud.png";
                description = "Nextcloud Suite";
                href = "https://cloud.darksailor.dev";
                ping = "cloud.darksailor.dev";
              };
            }
            {
              "Immich" = {
                icon = "immich.png";
                description = "Immich: Self-hosted Photo and Video Backup";
                href = "https://photos.darksailor.dev";
                ping = "photos.darksailor.dev";
              };
            }
            {
              "Excalidraw" = {
                icon = "excalidraw.png";
                description = "Excalidraw: Self-hosted Collaborative Whiteboard";
                href = "https://draw.darksailor.dev";
                ping = "draw.darksailor.dev";
              };
            }
            {
              "Navidrome" = {
                icon = "navidrome.png";
                description = "A self-hosted music server and streamer.";
                href = "https://music.darksailor.dev";
                ping = "music.darksailor.dev";
              };
            }
            {
              "OpenwebUI" = {
                icon = "open-webui.png";
                description = "OpenwebUI: Self-hosted AI chat interface";
                href = "https://chat.darksailor.dev";
                ping = "chat.darksailor.dev";
              };
            }
          ];
        }
      ];
      bookmarks = [
        {
          "Nix" = [
            {
              "Nixpkgs" = [
                {
                  abbr = "pkgs";
                  href = "https://search.nixos.org/packages?channel=unstable";
                }
              ];
            }
            {
              "NixOS" = [
                {
                  abbr = "nixos";
                  href = "https://search.nixos.org/options?channel=unstable";
                }
              ];
            }
            {
              "Home Manager" = [
                {
                  abbr = "hm";
                  href = "https://home-manager-options.extranix.com";
                }
              ];
            }
            {
              "NixVim" = [
                {
                  abbr = "nixvim";
                  href = "https://nix-community.github.io/nixvim/search";
                }
              ];
            }
            {
              "Tailscale" = [
                {
                  abbr = "ts";
                  href = "https://login.tailscale.com";
                }
              ];
            }
          ];
        }
      ];
    };
    caddy = {
      virtualHosts."dashboard.darksailor.dev".extraConfig = ''
        reverse_proxy localhost:${builtins.toString config.services.homepage-dashboard.listenPort}
      '';
    };
    # authelia = {
    #   instances.darksailor = {
    #     settings = {
    #       access_control = {
    #         rules = [
    #           {
    #             domain = "dashboard.darksailor.dev";
    #             policy = "one_factor";
    #           }
    #         ];
    #       };
    #     };
    #   };
    # };
  };
}
