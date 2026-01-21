{
  pkgs,
  device,
  ...
}: {
  stylix.targets.ghostty.enable = false;
  programs.ghostty = {
    enable = device.is "ryu";
    installBatSyntax = false;
    settings = {
      font-family = [
        "Hasklug Nerd Font Mono"
      ];
      window-decoration = false;
      title = "ghostty";
      command = "fish";
      background-opacity = 0.8;
      theme = "catppuccin-mocha";
      custom-shader = "~/.config/ghostty/shader.glsl";
      # custom-shader = toString (pkgs.writeText "shader.glsl"
      #   /*
      #   glsl
      #   */
      #   ''
      #     const float CURSOR_ANIMATION_SPEED = 150.0; // ms
      #     const float TRAILING_CURSORS = 3.0;
      #     bool at_pos(vec2 fragCoord, vec2 pos, vec2 size) {
      #         return (pos.x <= fragCoord.x && fragCoord.x <= pos.x + size.x &&
      #             pos.y - size.y <= fragCoord.y && fragCoord.y <= pos.y);
      #     }
      #     void mainImage(out vec4 fragColor, in vec2 fragCoord) {
      #         // Normalized pixel coordinates (from 0 to 1)
      #         vec2 uv = fragCoord / iResolution.xy;
      #         vec2 current_cursor = iCurrentCursor.xy;
      #         vec2 previous_cursor = iPreviousCursor.xy;
      #         float time_passed = (iTime - iTimeCursorChange) * 1000.0; // in ms
      #
      #         if (time_passed > CURSOR_ANIMATION_SPEED) {
      #             // No animation, just render normally
      #             fragColor = texture(iChannel0, uv);
      #             return;
      #         }
      #         // Animate cursor meovement
      #         vec4 col = texture(iChannel0, uv);
      #         // linear interpolation between current and previous cursor position based on time passed
      #         vec2 animated_cursor_pos = mix(previous_cursor, current_cursor, time_passed / CURSOR_ANIMATION_SPEED);
      #         // make 3 trailing cursors for smoother animation
      #         for (int i = 1; i <= int(TRAILING_CURSORS); i++) {
      #             float t = float(i) / TRAILING_CURSORS;
      #             vec2 trail_pos = mix(previous_cursor, current_cursor, (time_passed / CURSOR_ANIMATION_SPEED) * t);
      #             if (at_pos(fragCoord, trail_pos, iCurrentCursor.zw)) {
      #                 col = mix(col, iCurrentCursorColor, t);
      #             }
      #         }
      #
      #         // vec4 cursor_color = mix(iPreviousCursorColor, iCurrentCursorColor, time_passed / CURSOR_ANIMATION_SPEED);
      #         vec4 cursor_color = iCurrentCursorColor; // no color animation for now
      #         vec2 cursor_size = iCurrentCursor.zw;
      #         // check if fragCoord is within the animated cursor rectangle
      #         // y is in the negative direction
      #         // if (animated_cursor_pos.x <= fragCoord.x && fragCoord.x <= animated_cursor_pos.x + cursor_size.x &&
      #         //         animated_cursor_pos.y - cursor_size.y <= fragCoord.y && fragCoord.y <= animated_cursor_pos.y) {
      #         //     col = cursor_color;
      #         // }
      #         if (at_pos(fragCoord, animated_cursor_pos, cursor_size)) {
      #             col = cursor_color;
      #         }
      #
      #         fragColor = col;
      #     }
      #   '');
    };
    systemd.enable = true;
    themes = {
      catppuccin-mocha = {
        # background = "1e1e2e";
        background = "000000";
        cursor-color = "f5e0dc";
        foreground = "cdd6f4";
        palette = [
          "0=#45475a"
          "1=#f38ba8"
          "2=#a6e3a1"
          "3=#f9e2af"
          "4=#89b4fa"
          "5=#f5c2e7"
          "6=#94e2d5"
          "7=#bac2de"
          "8=#585b70"
          "9=#f38ba8"
          "10=#a6e3a1"
          "11=#f9e2af"
          "12=#89b4fa"
          "13=#f5c2e7"
          "14=#94e2d5"
          "15=#a6adc8"
        ];
        selection-background = "353749";
        selection-foreground = "cdd6f4";
      };
    };
  };
}
