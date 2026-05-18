{
  device,
  hl,
  lib,
  pkgs,
  ...
}: let
  mainMod = "SUPER";
  mainModShift = "SUPER + SHIFT";

  # hl.dsp.dpms(state, monitor) ignores `state` in this Hyprland Lua
  # build — it always toggles. Wrap with a state check so we only fire
  # toggles on monitors whose dpms doesn't match the desired state.
  hyprDpms = pkgs.writeShellApplication {
    name = "hypr-dpms";
    runtimeInputs = [pkgs.hyprland pkgs.jq];
    text = ''
      want="''${1:?usage: hypr-dpms on|off}"
      case "$want" in on) target=true;; off) target=false;; *) exit 2;; esac
      hyprctl monitors -j | jq -r '.[] | "\(.name) \(.dpmsStatus)"' \
        | while read -r name on; do
            if [ "$on" != "$target" ]; then
              hyprctl dispatch "hl.dsp.dpms(\"$want\", \"$name\")"
            fi
          done
    '';
  };

  mkDirBinds = mods: dsp: dirs:
    lib.mapAttrs'
    (key: direction:
      lib.nameValuePair "${mods} + ${key}" {
        inherit dsp;
        args = {inherit direction;};
      })
    dirs;

  mkWorkspaceBinds = mods: dsp:
    lib.listToAttrs (map (n: {
      name = "${mods} + ${toString (lib.mod n 10)}";
      value = {
        inherit dsp;
        args = {workspace = toString n;};
      };
    }) (lib.range 1 10));
in {
  imports = [../../modules/home/hyprland-lua.nix];

  # services.hyprpolkitagent.enable = true;
  services.hypridle = {
    enable = device.is "ryu";
    settings = {
      general = {
        after_sleep_cmd = "${lib.getExe hyprDpms} on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "${lib.getExe hyprDpms} off";
          on-resume = "${lib.getExe hyprDpms} on";
        }
      ];
    };
  };
  # services.hyprsunset = { enable = device.is "ryu"; };
  # programs.hyprlock  = { enable = device.is "ryu"; };

  stylix.targets.hyprland.enable = false;

  wayland.windowManager.hyprland = {
    enable = device.is "ryu";
    configType = "lua";
    systemd.enable = true;

    # exec_once equivalents — registered via hl.on("hyprland.start", …).
    extraConfig =
      /*
      lua
      */
      ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1")
        end)
      '';
    # -- hl.exec_cmd("${pkgs.swww}/bin/swww init")
    # -- hl.exec_cmd("${pkgs.ironbar}/bin/ironbar")
    # -- hl.exec_cmd("${pkgs.swayosd}/bin/swayosd-server")
    # -- hl.exec_cmd("${pkgs.nextcloud-client}/bin/nextcloud --background")

    settings = {
      config = {
        render = {
          cm_enabled = true;
          direct_scanout = 2; # 0 off | 1 on | 2 auto-by-`game`
          send_content_type = true;
          cm_auto_hdr = 2; # 0 off | 1 cm,hdr | 2 cm,hdredid
          non_shader_cm = 2;
        };

        ecosystem = {
          no_update_news = true;
        };

        input = {
          kb_layout = "us";
          kb_options = "ctrl:nocaps";
          follow_mouse = 2;
          touchpad = {
            natural_scroll = true;
            tap_to_click = true;
            disable_while_typing = true;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };

        animations = {
          enabled = true;
        };

        dwindle = {
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };
      };

      monitor = [
        {
          output = device.monitors.primary;
          mode = "2560x1440@360";
          position = "0x0";
          scale = 1;
          transform = 0;
          supports_wide_color = 1;
          supports_hdr = 1;
          min_luminance = 0.005;
          max_luminance = 400;
          max_avg_luminance = 300;
          bitdepth = 10;
          cm = "hdr";
          sdrbrightness = 1;
          sdrsaturation = 1;
        }
        {
          output = device.monitors.secondary;
          mode = "2560x1440@170";
          position = "-2560x0";
          scale = 1;
          transform = 0;
        }
        {
          output = device.monitors.tertiary;
          mode = "2560x1440@170";
          position = "2560x-875";
          scale = 1;
          transform = 3;
        }
      ];

      env = hl.envs {
        XCURSOR_SIZE = "24";
        XDG_SESSION_TYPE = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        QT_QPA_PLATFORM = "wayland";
      };

      curve = hl.curves {
        myBezier = {
          type = "bezier";
          points = [[0.05 0.9] [0.1 1.05]];
        };
      };

      animation = hl.animations [
        {
          leaf = "windows";
          enabled = true;
          speed = 2;
          bezier = "myBezier";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 2;
          bezier = "default";
          style = "popin 80%";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "borderangle";
          enabled = true;
          speed = 8;
          bezier = "default";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 2;
          bezier = "default";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 2;
          bezier = "default";
        }
      ];

      window_rule = hl.windowRules [
        {
          match = {title = "^(Archetype.*)$";};
          float = true;
        }
        {
          match = {class = "(.*nextcloud.*)";};
          float = true;
        }
        {
          match = {class = "org.kde.kdeconnect.app";};
          float = true;
        }
      ];

      workspace_rule = hl.workspaceRules (
        map (n: {
          workspace = toString n;
          monitor = device.monitors.primary;
        }) [1 2 3 4]
        ++ map (n: {
          workspace = toString n;
          monitor = device.monitors.secondary;
        }) [5 6 7]
        ++ map (n: {
          workspace = toString n;
          monitor = device.monitors.tertiary;
        }) [8 9 10]
      );

      bind = hl.binds (lib.mergeAttrsList [
        # Terminals + utilities
        {
          "${mainMod} + Return" = "${lib.getExe pkgs.kitty}";
          "${mainModShift} + Return" = "${lib.getExe pkgs.ghostty}";
          "${mainModShift} + Q" = {dsp = "window.close";};
          "${mainModShift} + S" = "${lib.getExe pkgs.hyprshot} -m region -o ~/Pictures/Screenshots/";
          "${mainMod} + D" = "${lib.getExe pkgs.vicinae} toggle";
          "${mainMod} + Space" = "${lib.getExe pkgs.vicinae} toggle";
          "${mainMod} + A" = "${pkgs.swaynotificationcenter}/bin/swaync-client -t";
          "Print" = "${lib.getExe pkgs.hyprshot} -m output -o ~/Pictures/Screenshots/";

          # Window state (was: togglefloating + pin + alterzorder top on one key)
          "${mainModShift} + F" = {
            multi = [
              (hl.dsp.call "window.float" {action = "toggle";})
              (hl.dsp.call "window.pin" null)
              (hl.dsp.call "window.alter_zorder" {mode = "top";})
            ];
          };
          "${mainMod} + F" = {
            dsp = "window.fullscreen";
            args = {action = "toggle";};
          };
          "${mainMod} + G" = {
            dsp = "window.fullscreen_state";
            args = {
              internal = 0;
              client = 2;
            };
          };
          "${mainMod} + P" = {
            dsp = "window.pseudo";
            args = {action = "toggle";};
          };
          "${mainMod} + V" = {
            dsp = "layout";
            args = ["togglesplit"];
          };
          "${mainMod} + Tab" = {dsp = "window.cycle_next";};

          # Media keys
          "XF86AudioMute" = "${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle";
          "XF86AudioPrev" = "${lib.getExe pkgs.playerctl} previous";
          "XF86AudioNext" = "${lib.getExe pkgs.playerctl} next";
          "XF86AudioPlay" = "${lib.getExe pkgs.playerctl} play-pause";
          "XF86MonBrightnessUp" = "${lib.getExe pkgs.ddcbacklight} inc 10";
          "XF86MonBrightnessDown" = "${lib.getExe pkgs.ddcbacklight} dec 10";

          # Volume (originally `binde`, repeating)
          "XF86AudioRaiseVolume" = {
            exec = "${pkgs.swayosd}/bin/swayosd-client --output-volume raise";
            flags = {repeating = true;};
          };
          "XF86AudioLowerVolume" = {
            exec = "${pkgs.swayosd}/bin/swayosd-client --output-volume lower";
            flags = {repeating = true;};
          };

          # Workspace scroll
          "${mainMod} + mouse_down" = {
            dsp = "focus";
            args = {workspace = "e+1";};
          };
          "${mainMod} + mouse_up" = {
            dsp = "focus";
            args = {workspace = "e-1";};
          };
        }

        # Focus directions: arrows + hjkl.
        (mkDirBinds mainMod "focus" {
          left = "l";
          right = "r";
          up = "u";
          down = "d";
          h = "l";
          j = "d";
          k = "u";
          l = "r";
        })

        # Move window: hjkl only.
        (mkDirBinds mainModShift "window.move" {
          h = "l";
          j = "d";
          k = "u";
          l = "r";
        })

        # Workspace switch / move-to: 1..0 → ws 1..10.
        (mkWorkspaceBinds mainMod "focus")
        (mkWorkspaceBinds mainModShift "window.move")

        # Mouse binds (was bindm).
        {
          "${mainMod} + mouse:272" = {
            dsp = "window.drag";
            flags = {mouse = true;};
          };
          "${mainMod} + mouse:273" = {
            dsp = "window.resize";
            flags = {mouse = true;};
          };
        }
      ]);
    };
  };
}
