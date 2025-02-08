{...}: {
  services = {
    yabai = {
      enable = true;
      enableScriptingAddition = true;
      config = {
        mouse_follows_focus = "on";
        focus_follows_mouse = "on";
        window_origin_display = "default";
        window_placement = "second_child";
        window_topmost = "off";
        window_shadow = "on";
        window_opacity = "off";
        window_opacity_duration = "0.0";
        active_window_opacity = "1.0";
        normal_window_opacity = "0.90";
        window_border = "off";
        window_border_width = "6";
        active_window_border_color = "0xff775759";
        normal_window_border_color = "0xff555555";
        insert_feedback_color = "0xffd75f5f";
        split_ratio = "0.50";
        auto_balance = "off";
        mouse_modifier = "fn";
        mouse_action1 = "move";
        mouse_action2 = "resize";
        mouse_drop_action = "swap";
        layout = "bsp";
        top_padding = "5";
        bottom_padding = "5";
        left_padding = "5";
        right_padding = "5";
        window_gap = "06";
      };

      extraConfig = ''
        yabai -m rule --add app='System Preferences' manage=off
        yabai -m rule --add app="choose" manage=off
        yabai -m rule --add app="barrier" manage=off
      '';
    };
  };
}
