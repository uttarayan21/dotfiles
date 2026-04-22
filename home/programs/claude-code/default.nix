{device, ...}: {
  programs.claude-code = {
    enable = !device.isServer;
    settings = {
      statusLine = {
        type = "command";
        padding = 0;
        command = "~/.local/bin/starship-claude";
      };
      enabledPlugins = {
        "rust-analyzer-lsp@claude-plugins-official" = true;
        "caveman@caveman" = true;
        "starship-claude@starship-claude" = true;
      };
      extraKnownMarketplaces = {
        caveman = {
          source = {
            source = "github";
            repo = "JuliusBrussee/caveman";
          };
        };
        starship-claude = {
          source = {
            source = "github";
            repo = "martinemde/starship-claude";
          };
        };
      };
      alwaysThinkingEnabled = true;
      effortLevel = "high";
    };
  };

  home.file = {
    ".claude/starship.toml".source = ./starship.toml;
    ".local/bin/starship-claude" = {
      source = ./starship-claude;
      executable = true;
    };
  };
}
