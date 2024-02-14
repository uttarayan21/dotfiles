{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fs0c131y";
  home.homeDirectory = "/home/fs0c131y";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [
    # Include the results of the hardware scan.
    ./tmux.nix
  ];

  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        vim = "nvim";
        vi = "nvim";
        nv = "nvim";
        g = "git";
        cd = "z";
        ls = "exa";
      };
      interactiveShellInit = ''
        # Add the following line to your ~/.config/fish/config.fish to enable
        # Home Manager's Fish integration.
        # source ${config.home.homeDirectory}/.nix-profile/share/hm-session-vars/hm-session-vars.fish
        set fish_greeting
        # macchina
      '';
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
    carapace = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    nushell = {
      enable = true;
      package = pkgs.nushellFull;
    };

    keychain = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };


    wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require 'wezterm';
        return {
            -- -- font = wezterm.font("Hasklug Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" }),
            -- font = wezterm.font_with_fallback({
            --      "Hasklig",
            --      "Symbols Nerd Font Mono"
            -- }),

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
            initial_cols = 120,
            hide_tab_bar_if_only_one_tab = true,
            window_background_opacity = 0.8,
            cursor_blink_rate = 8,
            default_cursor_style = "BlinkingBlock",
            default_prog = { "${pkgs.fish.outPath}/bin/fish", "-l" },
            window_padding = {
                left = 2,
                right = 0,
                top = 2,
                bottom = 0,
            },
            window_decorations = "RESIZE",
            use_ime = false,
        }
      '';
    };

  };

  home.packages = [
    pkgs.macchina
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
