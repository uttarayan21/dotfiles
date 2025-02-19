{
  pkgs,
  device,
  ...
}: {
  programs.wezterm = {
    enable = true;
    extraConfig =
      /*
      lua
      */
      ''
        return {
            term = "wezterm",
            font = wezterm.font_with_fallback({
                 "Hasklug Nerd Font Mono",
                 "Symbols Nerd Font Mono"
            }),
            color_scheme = "Catppuccin Mocha",
            colors = {
                background = "#000000",
            },
            font_size = 16,
            initial_cols = 200,
            hide_tab_bar_if_only_one_tab = true,
            window_background_opacity = 0.8,
            -- background = {{source = {Color = "black"}}},
            -- cursor_blink_rate = 8,
            -- default_cursor_style = "BlinkingBlock",
            default_prog = { "${pkgs.fish}/bin/fish", "-l" },
            window_padding = {
                left = 2,
                right = 0,
                top = 2,
                bottom = 0,
            },
            window_decorations = "${
          if pkgs.stdenv.isLinux
          then "NONE"
          else "RESIZE"
        }",
            use_ime = false,
        }
      '';
  };
}
