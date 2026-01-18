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
      #     void mainImage(out vec4 fragColor, in vec2 fragCoord) {
      #         vec2 uv = fragCoord / iResolution.xy;
      #         vec3 col = vec3(0.0);
      #         col.r = 0.1 + 0.9 * uv.x;
      #         col.g = 0.1 + 0.9 * uv.y;
      #         col.b = 0.2;
      #         fragColor = vec4(col, 1.0);
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
