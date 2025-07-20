{
  inputs,
  pkgs,
  device,
  ...
}: {
  imports = [inputs.ironbar.homeManagerModules.default];
  programs.ironbar = {
    enable = device.hasGui && pkgs.stdenv.isLinux;
    package = inputs.ironbar.packages.${pkgs.system}.default;
    systemd = true;
    config.monitors = {
      "${device.monitors.secondary}" = {
        position = "bottom";
        start = [
          {
            type = "launcher";
            favourites = ["firefox" "discord"];
            show_names = false;
            show_icons = true;
          }
          {type = "focused";}
        ];
        end = [
          {
            type = "clipboard";
            max_items = 3;
            truncate.length = 50;
            truncate.mode = "end";
          }
          {
            type = "music";
            player_type = "mpris";
          }
          {type = "clock";}
        ];
      };
      "${device.monitors.primary}" = {
        position = "bottom";
        icon_theme = "Papirus-Dark";
        end = [
          {
            type = "sys_info";
            format = [
              "  CPU {cpu_percent}% | {temp_c:coretemp-Package-id-0}°C"
              "  RAM {memory_used}GB/{memory_total}GB"
            ];
            interval = {
              cpu = 1;
              temps = 5;
              memory = 30;
              # disks= 300;
              # networks= 3;
            };
          }
          {type = "tray";}
        ];
        start = [
          {
            type = "workspaces";
            name_map = {
              "1" = "icon:foot";
              "2" = "icon:code";
              "3" = "icon:firefox";
              "4" = "icon:slack";
              "5" = "icon:steam";
              "6" = "icon:foot";
              "7" = "icon:foot";
              "8" = "icon:firefox";
              "9" = "icon:discord";
              "10" = "icon:spotify";
            };
            favorites = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"];
            all_monitors = true;
          }
        ];
      };
      "${device.monitors.tertiary}" = {
        position = "bottom";
        icon_theme = "Papirus-Dark";
        start = [
          {
            type = "launcher";
            show_names = false;
            show_icons = true;
          }
          {type = "focused";}
        ];
        end = [
          {type = "clock";}
        ];
      };
    };
    style = let
      catppuccin = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "waybar";
        rev = "v1.0";
        sha256 = "sha256-vfwfBE3iqIN1cGoItSssR7h0z6tuJAhNarkziGFlNBw";
      };
      mocha = builtins.readFile "${catppuccin}/mocha.css";
    in
      mocha + builtins.readFile ./ironbar.css;
  };
}
