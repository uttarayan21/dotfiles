{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      source =
        # let
        #   catppuccin = pkgs.fetchFromGitHub {
        #     owner = "catppuccin";
        #     repo = "hyprland";
        #     rev = "main";
        #     sha256 = "sha256-9BhZq9J1LmHfAPBqOr64chiAEzS+YV6zqe9ma95V3no";
        #   };
        # in
        "${pkgs.catppuccinThemes.hyprland}/themes/mocha.conf";
      monitor = [
        ",preferred,auto,auto"
        "DP-1,       2560x1440@170, 0x0,     1, transform, 0"
        "HDMI-A-2,   2560x1440@144, -1440x-800,1, transform, 1"
        ",highrr,auto,1"
      ];

      input = {
        kb_layout = "us";
        # kb_variant = "";
        # kb_model = "";
        kb_options = "ctrl:nocaps";
        # kb_rules = "";

        follow_mouse = 0;

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
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
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
        new_is_master = true;
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = false;
      };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      "device:epic-mouse-v1" = { sensitivity = -0.5; };

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

      windowrule = [ "float, title:^(Steam)$" "float, title:^(Archetype.*)$" ];

      "misc:vfr" = true;

      env = [
        "XCURSOR_SIZE,24"
        "XDG_SESSION_TYPE,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_QPA_PLATFORM,wayland"
      ];
      exec-once = [
        "${pkgs.swayosd}/bin/swayosd-server"
        # "${pkgs.swww}/bin/swww init; swww img ~/.local/share/dotfiles/images/wallpaper.jpg"
        "${pkgs.ironbar}/bin/ironbar"
        "${pkgs.nextcloud-client}/bin/nextcloud --background"
        "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
      ];

      "$mainMod" = "SUPER";
      "$mainModShift" = "SUPER_SHIFT";

      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mainMod, Return, exec, ${pkgs.foot}/bin/foot"
        "$mainModShift, Return, exec, ${pkgs.wezterm}/bin/wezterm"
        "$mainModShift, Q, killactive,"
        # "$mainMod, M, exit,"
        "$mainMod, t, togglefloating,"
        "$mainMod, f, fullscreen,"
        "$mainMod, d, exec, ${pkgs.anyrun}/bin/anyrun"
        "$mainMod, Space, exec, ${pkgs.anyrun}/bin/anyrun"
        "$mainMod, p, pseudo, # dwindle"
        "$mainMod, v, togglesplit,"
        "$mainMod, a, exec, swaync-client -t"
        "$mainMod, Tab, cyclenext"
        # Audio
        ",xf86audioraisevolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume raise"
        ",xf86audiolowervolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume lower"
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
        "1,  monitor:DP-1"
        "2,  monitor:DP-1"
        "3,  monitor:DP-1"
        "4,  monitor:DP-1"
        "5,  monitor:DP-1"
        "6,  monitor:DP-1"
        "7,  monitor:DP-1"
        "8,  monitor:HDMI-A-2"
        "9,  monitor:HDMI-A-2"
        "10, monitor:HDMI-A-2"
      ];
    };
  };
}
