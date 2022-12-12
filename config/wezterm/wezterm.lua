local wezterm = require 'wezterm';

return {
    font = wezterm.font("Hasklug Nerd Font"),
    font_size = 16,
    colors = {
        -- The default text color
        foreground = "#f8f8f2",
        -- The default background color
        -- background = "#282a36",
        -- Overrides the cell background color when the current cell is occupied by the
        -- cursor and the cursor style is set to Block
        cursor_bg = "#f8f8f2",
        -- Overrides the text color when the current cell is occupied by the cursor
        cursor_fg = "#000",
        -- Specifies the border color of the cursor when the cursor style is set to Block,
        -- or the color of the vertical or horizontal bar when the cursor style is set to
        -- Bar or Underline.
        cursor_border = "#52ad70",
        -- the foreground color of selected text
        selection_fg = "#ffffff",
        -- the background color of selected text
        selection_bg = "#ffffff",
        -- The color of the scrollbar "thumb"; the portion that represents the current viewport
        scrollbar_thumb = "#222222",
        -- The color of the split lines between panes
        split = "#444444",
        ansi = { "#21222c", "#ff5555", "#50fa7b", "#f1fa8c", "#bd93f9", "#ff79c6", "#8be9fd", "#f8f8f2" },
        brights = { "#6272a4", "#ff6e6e", "#69ff94", "#ffffa5", "#d6acff", "#ff92df", "#a4ffff", "#ffffff" },
        -- Arbitrary colors of the palette in the range from 16 to 255
        indexed = { [136] = "#af8700" },
        -- Since: nightly builds only
        -- When the IME, a dead key or a leader key are being processed and are effectively
        -- holding input pending the result of input composition, change the cursor
        -- to this color to give a visual cue about the compose state.
        compose_cursor = "orange",
    },
    hide_tab_bar_if_only_one_tab = true,
    window_background_opacity = 0.8,
    cursor_blink_rate = 880,
    default_cursor_style = "BlinkingBlock",
    default_prog = { "/opt/homebrew/bin/fish", "-l" },
    window_padding = {
        left = 0,
        right = 0,
        top = 2,
        bottom = 0,
    },
    window_decorations = "RESIZE",
    use_ime = false,
}
