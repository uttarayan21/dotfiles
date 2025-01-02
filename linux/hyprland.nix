{
  pkgs,
  device,
  ...
}: {
  imports = [
    ../modules/hyprpaper.nix
  ];

  programs.hyprpaper = let
    wallpapers = import ../utils/wallhaven.nix {inherit pkgs;};
  in {
    enable = device.hasGui;
    # enable = true;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
    settings.preload = wallpapers.all;
    settings.wallpapers = {
      "${device.monitors.primary}" = wallpapers.skull;
      "${device.monitors.secondary}" = wallpapers.frieren_3;
      "${device.monitors.tertiary}" = wallpapers.cloud;
    };
  };
  programs.hyprlock = {
    enable = device.hasGui;
  };
  wayland.windowManager.hyprland = {
    enable = device.hasGui;

    settings = {
      source = "${pkgs.catppuccinThemes.hyprland}/themes/mocha.conf";
      "render:explicit_sync" = true;
      monitor = [
        "${device.monitors.primary},    2560x1440@240,          0x0,     1, transform, 0"
        "${device.monitors.secondary},  2560x1440@170,  -1440x-1120,     1, transform, 1"
        "${device.monitors.tertiary},   2560x1440@170,   2560x-1120,     1, transform, 3"
      ];

      input = {
        kb_layout = "us";
        # kb_variant = "";
        # kb_model = "";
        kb_options = "ctrl:nocaps";
        # kb_rules = "";

        follow_mouse = 2;

        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          disable_while_typing = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "$mauve $mauve 45deg";
        "col.inactive_border" = "$crust";
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10;
        # drop_shadow = true;
        # shadow_range = 4;
        # shadow_render_power = 3;
        # col.shadow = "rgba(1a1a1aee)";

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        enabled = true;

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile =
          true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_status = "master";
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = false;
      };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      # "device:epic-mouse-v1" = { sensitivity = -0.5; };

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

      windowrulev2 = [
        "float, title:^(Steam)$"
        "float, title:^(Archetype.*)$"
        "float, class:(.*nextcloud.*)"
        "float, class:org.kde.kdeconnect.app"
      ];

      # "misc:vfr" = true;

      env = [
        "XCURSOR_SIZE,24"
        "XDG_SESSION_TYPE,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_QPA_PLATFORM,wayland"
      ];
      exec-once = [
        # "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
        "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1"
        # "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        # "${pkgs.swww}/bin/swww init; swww img ~/.local/share/dotfiles/images/wallpaper.jpg"
        "${pkgs.ironbar}/bin/ironbar"
        # "${pkgs.swayosd}/bin/swayosd-server"
        "${pkgs.nextcloud-client}/bin/nextcloud --background"
      ];

      "$mainMod" = "SUPER";
      "$mainModShift" = "SUPER_SHIFT";

      binde = [
        ",xf86audioraisevolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume raise"
        ",xf86audiolowervolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume lower"
      ];
      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mainMod, Return, exec, ${pkgs.kitty}/bin/kitty"
        "$mainModShift, Return, exec, ${pkgs.foot}/bin/foot"
        "$mainModShift, Q, killactive,"
        # "$mainMod, M, exit,"
        "$mainMod, t, togglefloating,"
        "$mainMod, f, fullscreen,"
        "$mainMod, d, exec, ${pkgs.anyrun}/bin/anyrun"
        "$mainMod, Space, exec, ${pkgs.anyrun}/bin/anyrun"
        "$mainMod, p, pseudo, # dwindle"
        "$mainMod, v, togglesplit,"
        # "$mainMod, a, exec, swaync-client -t"
        "$mainMod, Tab, cyclenext"
        # Audio
        ",xf86audiomute, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle"
        # ",xf86audioprev, exec, /home/fs0c131y/.cargo/bin/mctl prev"
        # ",xf86audionext, exec, /home/fs0c131y/.cargo/bin/mctl next"
        # ",xf86audioplay, exec, /home/fs0c131y/.cargo/bin/mctl toggle"

        # Screenshot
        # "$mainMod,Print, exec, grim"
        # "$mainModShift,Print, exec, grim -g "$(slurp)""
        "$mainModShift,s, exec, ${pkgs.watershot}/bin/watershot"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, h, movefocus, l"
        "$mainMod, j, movefocus, d"
        "$mainMod, k, movefocus, u"
        "$mainMod, l, movefocus, r"

        "$mainModShift, h, movewindow, l"
        "$mainModShift, j, movewindow, d"
        "$mainModShift, k, movewindow, u"
        "$mainModShift, l, movewindow, r"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        "$mainMod, Tab, cyclenext, bind = ALT, Tab, bringactivetotop,"
      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      workspace = [
        "1,  monitor:${device.monitors.primary}"
        "2,  monitor:${device.monitors.primary}"
        "3,  monitor:${device.monitors.primary}"
        "4,  monitor:${device.monitors.primary}"
        "5,  monitor:${device.monitors.secondary}"
        "6,  monitor:${device.monitors.secondary}"
        "7,  monitor:${device.monitors.secondary}"
        "8,  monitor:${device.monitors.tertiary}"
        "9,  monitor:${device.monitors.tertiary}"
        "10, monitor:${device.monitors.tertiary}"
      ];
    };
  };
}
