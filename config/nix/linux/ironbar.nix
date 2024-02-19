{ inputs, ... }: {
  imports = [ inputs.ironbar.homeManagerModules.default ];
  programs.ironbar = {
    enable = true;
    config.monitors = {
      HDMI-A-2 = {
        position = "bottom";
        start = [
          {
            type = "launcher";
            favourites = [ "firefox" "discord" ];
            show_names = false;
            show_icons = true;
          }
          { type = "focused"; }
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
          { type = "clock"; }
        ];
      };
      DP-1 = {
        position = "bottom";
        icon_theme = "Papirus-Dark";
        end = [
          {
            type = "sys_info";
            format = [
              "  CPU {cpu_percent}% | {temp_c=coretemp-Package-id-0}°C"
              "  RAM {memory_percent}%"
              # -   {disk_used=/home} GiB / {disk_total:/home} GiB ({disk_percent:/home}%)
              # - 猪  {load_average=1} | {load_average:5} | {load_average:15}
              # - 李 {net_down=eno1} / {net_up:eno1} Mbps
              # -   {uptime}
            ];
            interval = {
              cpu = 1;
              temps = 5;
              memory = 30;
              # disks= 300;
              # networks= 3;
            };
          }
          { type = "tray"; }
        ];
        start = [{
          type = "workspaces";
          name_map = {
            "1" = "icon:code";
            "2" = "";
            "3" = "icon:chrome";
            "4" = "icon:discord";
            "5" = "icon:steam";
            "6" = "icon:misc";
            "7" = "icon:misc";
            "8" = "icon:docky";
            "9" = "icon:monodoc";
            "10" = "icon:spotify";
          };
          favorites = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ];
          all_monitors = true;
        }];
      };
    };
    style = ''
      @define-color color_bg #2d2d2d;
      @define-color color_bg_dark #1c1c1c;
      @define-color color_border #424242;
      @define-color color_border_active #6699cc;
      @define-color color_text #ffffff;
      @define-color color_urgent #8f0a0a;

      /* -- base styles -- */

      * {
          font-family: Noto Sans Nerd Font, sans-serif;
          font-size: 16px;
          border: none;
          border-radius: 0;
      }

      box, menubar, button {
          background-color: @color_bg;
          background-image: none;
      }

      button, label {
          color: @color_text;
      }

      button:hover {
          background-color: @color_bg_dark;
      }

      #bar {
          border-top: 1px solid @color_border;
      }

      .popup {
          border: 1px solid @color_border;
          padding: 1em;
      }


      /* -- clipboard -- */

      .clipboard {
          margin-left: 5px;
          font-size: 1.1em;
      }

      .popup-clipboard .item {
          padding-bottom: 0.3em;
          border-bottom: 1px solid @color_border;
      }


      /* -- clock -- */

      .clock {
          font-weight: bold;
          margin-left: 5px;
      }

      .popup-clock .calendar-clock {
          color: @color_text;
          font-size: 2.5em;
          padding-bottom: 0.1em;
      }

      .popup-clock .calendar {
          background-color: @color_bg;
          color: @color_text;
      }

      .popup-clock .calendar .header {
          padding-top: 1em;
          border-top: 1px solid @color_border;
          font-size: 1.5em;
      }

      .popup-clock .calendar:selected {
          background-color: @color_border_active;
      }


      /* -- launcher -- */

      .launcher .item {
          margin-right: 4px;
      }

      .launcher .item:not(.focused):hover {
          background-color: @color_bg_dark;
      }

      .launcher .open {
          border-bottom: 1px solid @color_text;
      }

      .launcher .focused {
          border-bottom: 2px solid @color_border_active;
      }

      .launcher .urgent {
          border-bottom-color: @color_urgent;
      }

      .popup-launcher {
          padding: 0;
      }

      .popup-launcher .popup-item:not(:first-child) {
          border-top: 1px solid @color_border;
      }


      /* -- music -- */

      .music:hover * {
          background-color: @color_bg_dark;
      }

      .popup-music .album-art {
          margin-right: 1em;
      }

      .popup-music .icon-box {
          margin-right: 0.4em;
      }

      .popup-music .title .icon, .popup-music .title .label {
          font-size: 1.7em;
      }

      .popup-music .controls *:disabled {
          color: @color_border;
      }

      .slider slider {
          color: @color_urgent;
          background-color: @color_urgent;
      }

      .popup-music .volume .slider slider {
          border-radius: 100%;
      }

      .popup-music .volume .icon {
          margin-left: 4px;
      }

      .popup-music .progress .slider slider {
          border-radius: 100%;
      }

      /* -- script -- */

      .script {
          padding-left: 10px;
      }


      /* -- sys_info -- */

      .sysinfo {
          margin-left: 10px;
      }

      .sysinfo .item {
          margin-left: 5px;
      }


      /* -- tray -- */

      .tray {
          margin-left: 10px;
      }


      /* -- workspaces -- */

      .workspaces .item.focused {
          box-shadow: inset 0 -3px;
          background-color: @color_bg_dark;
      }

      .workspaces .item:hover {
          box-shadow: inset 0 -3px;
      }


      /* -- custom: power menu -- */

      .popup-power-menu #header {
          font-size: 1.4em;
          padding-bottom: 0.4em;
          margin-bottom: 0.6em;
          border-bottom: 1px solid @color_border;
      }

      .popup-power-menu .power-btn {
          border: 1px solid @color_border;
          padding: 0.6em 1em;
      }

      .popup-power-menu #buttons > *:nth-child(1) .power-btn {
          margin-right: 1em;
      }

    '';
  };
}
