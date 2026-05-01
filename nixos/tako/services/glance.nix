{config, ...}: let
  port = 8080;
in {
  networking.domains.subDomains."dashboard.darksailor.dev" = {};

  services = {
    glance = {
      enable = true;
      settings = {
        server = {
          host = "127.0.0.1";
          inherit port;
        };
        branding = {
          custom-footer = "Servius' Dashboard";
        };
        pages = [
          {
            name = "Home";
            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "monitor";
                    title = "Tako";
                    cache = "5m";
                    sites = [
                      {
                        title = "Gitea";
                        url = "https://git.darksailor.dev";
                        icon = "di:gitea";
                      }
                      {
                        title = "Grafana";
                        url = "https://grafana.darksailor.dev";
                        icon = "di:grafana";
                        alt-status-codes = [401];
                      }
                      {
                        title = "Nextcloud";
                        url = "https://cloud.darksailor.dev";
                        icon = "di:nextcloud";
                      }
                      {
                        title = "Immich";
                        url = "https://photos.darksailor.dev";
                        icon = "di:immich";
                      }
                      {
                        title = "Excalidraw";
                        url = "https://draw.darksailor.dev";
                        icon = "di:excalidraw";
                      }
                      {
                        title = "Navidrome";
                        url = "https://music.darksailor.dev";
                        icon = "di:navidrome";
                        alt-status-codes = [401];
                      }
                      {
                        title = "OpenWebUI";
                        url = "https://chat.darksailor.dev";
                        icon = "di:open-webui";
                        alt-status-codes = [401];
                      }
                      {
                        title = "Prowlarr";
                        url = "https://prowlarr.darksailor.dev";
                        icon = "di:prowlarr";
                        alt-status-codes = [401];
                      }
                    ];
                  }
                  {
                    type = "monitor";
                    title = "Tsuba";
                    cache = "5m";
                    sites = [
                      {
                        title = "Jellyfin";
                        url = "https://jellyfin.tsuba.darksailor.dev";
                        icon = "di:jellyfin";
                      }
                      {
                        title = "Sonarr";
                        url = "https://sonarr.tsuba.darksailor.dev";
                        icon = "di:sonarr";
                        alt-status-codes = [401];
                      }
                      {
                        title = "Radarr";
                        url = "https://radarr.tsuba.darksailor.dev";
                        icon = "di:radarr";
                        alt-status-codes = [401];
                      }
                      {
                        title = "Bazarr";
                        url = "https://bazarr.tsuba.darksailor.dev";
                        icon = "di:bazarr";
                        alt-status-codes = [401];
                      }
                      {
                        title = "Deluge";
                        url = "https://deluge.tsuba.darksailor.dev";
                        icon = "di:deluge";
                      }
                      {
                        title = "Aria2";
                        url = "https://aria2.tsuba.darksailor.dev";
                        icon = "di:ariang.png";
                      }
                      {
                        title = "Home Assistant";
                        url = "https://home.darksailor.dev";
                        icon = "di:home-assistant";
                      }
                      {
                        title = "Pi-hole";
                        url = "https://pihole.darksailor.dev";
                        icon = "di:pi-hole";
                      }
                    ];
                  }
                ];
              }
              {
                size = "full";
                widgets = [
                  {
                    type = "rss";
                    title = "News";
                    style = "horizontal-cards";
                    cache = "30m";
                    feeds = [
                      {
                        url = "https://rsshub.darksailor.dev/hackernews/best";
                        title = "Hacker News";
                      }
                      {
                        url = "https://rsshub.darksailor.dev/phoronix";
                        title = "Phoronix";
                      }
                    ];
                  }
                  {
                    type = "bookmarks";
                    groups = [
                      {
                        title = "Nix";
                        links = [
                          {
                            title = "Nixpkgs";
                            url = "https://search.nixos.org/packages?channel=unstable";
                          }
                          {
                            title = "NixOS Options";
                            url = "https://search.nixos.org/options?channel=unstable";
                          }
                          {
                            title = "Home Manager";
                            url = "https://home-manager-options.extranix.com";
                          }
                          {
                            title = "NixVim";
                            url = "https://nix-community.github.io/nixvim/search";
                          }
                        ];
                      }
                      {
                        title = "Network";
                        links = [
                          {
                            title = "Tailscale";
                            url = "https://login.tailscale.com";
                          }
                          {
                            title = "Cloudflare";
                            url = "https://dash.cloudflare.com";
                          }
                        ];
                      }
                    ];
                  }
                ];
              }
              {
                size = "small";
                widgets = [
                  {
                    type = "server-stats";
                    servers = [
                      {
                        type = "local";
                        name = "Tako";
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };
    };
    caddy = {
      virtualHosts."dashboard.darksailor.dev".extraConfig = ''
        import auth
        reverse_proxy localhost:${toString port}
      '';
    };
    authelia = {
      instances.darksailor = {
        settings = {
          access_control = {
            rules = [
              {
                domain = "dashboard.darksailor.dev";
                policy = "one_factor";
              }
            ];
          };
        };
      };
    };
  };
}
