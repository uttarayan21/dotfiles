{ config, pkgs, lib, device, ... }:
let
  # https://mipmip.github.io/home-manager-option-search/
  start-tmux = (import ../scripts/start-tmux.nix) pkgs;
  lazy = false;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./tmux.nix
    ./wezterm.nix
  ] ++ lib.optionals device.isLinux [ ../linux ]
  ++ lib.optionals (!lazy) [ ./nvim ];

  home.packages = with pkgs;
    [
      gnupg
      # gpg-tui
      comma
      # neovide
      sqls
      vcpkg
      file
      yt-dlp
      ngrok
      slack
      gh
      yarn
      just
      jq
      tldr
      # spotify-player
      bottom
      qmk
      nodejs
      macchina
      ripgrep
      fd
      nixfmt
      dust
      cachix
      rustup
      cmake
      fzf
      clang
      neovim-nightly
      nil
      pkg-config
      lua-language-server
      (nerdfonts.override { fonts = [ "Hasklig" ]; })
      mpv
    ] ++ lib.optionals device.isLinux [
      psst
      gnome.seahorse
      gnome.nautilus
      nextcloud-client
      sbctl
      gparted
      gptfdisk
      polkit_gnome
      dig
      mullvad
      steam-run
      (pkgs.catppuccin-gtk.override {
        variant = "mocha";
        size = "standard";
        accents = [ "mauve" ];
        tweaks = [ "normal" ];
      })
      (pkgs.catppuccin-papirus-folders.override {
        accent = "mauve";
        flavor = "mocha";
      })
      usbutils
      handlr-regex
      webcord-vencord
      spotify
      lsof
      wl-clipboard
      ncpamixer
      (pkgs.writeShellApplication {
        name = "xdg-open";
        runtimeInputs = [ handlr-regex ];
        text = ''
          handlr open "$@"
        '';
      })
    ] ++ lib.optionals device.isMac [ ];

  # xdg.enable = true;

  programs = {
    helix = {
      enable = true;
      settings = {
        theme = "base16";
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
        };
        keys.normal = {
          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
          esc = [ "collapse_selection" "keep_primary_selection" ];
        };
      };
    };
    git = {
      enable = true;
      userName = "uttarayan21";
      userEmail = "email@uttarayan.me";
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    fish = {
      enable = true;
      shellAbbrs = {
        vim = "nvim";
        vi = "nvim";
        nv = "neovide";
        g = "git";
        yy = "yazi";
        cd = "z";
        ls = "eza";
        t = "${start-tmux}";
      };
      shellAliases = { g = "git"; };
      shellInit = ''
        set fish_greeting
        yes | fish_config theme save "Catppuccin Mocha"
      '';
      interactiveShellInit = ''
        ${pkgs.spotify-player}/bin/spotify_player generate fish | source
        ${pkgs.macchina}/bin/macchina
      '';
    };

    nushell = {
      enable = true;
      shellAliases = {
        cd = "z";
        yy = "yazi";
        nv = "neovide";
      };
      package = pkgs.nushellFull;
      configFile.text = ''
        $env.config = {
            show_banner: false,
        }
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
      settings =
        let flavour = "mocha"; # Replace with your preferred palette
        in {
          # Other config here
          format = "$all"; # Remove this line to disable the default prompt format
          palette = "catppuccin_${flavour}";
        } // builtins.fromTOML (builtins.readFile
          (pkgs.catppuccinThemes.starship + /palettes/${flavour}.toml));
    };
    eza = {
      enable = true;
      # enableAliases = true;
      git = true;
      icons = true;
    };
    carapace = {
      enable = true;
      # enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    fzf = {
      enable = true;
      package = pkgs.fzf;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
    };
    yazi = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    bat = {
      enable = true;
      config = { theme = "catppuccin"; };
      themes = {
        catppuccin = {
          src = "${pkgs.catppuccinThemes.bat}/themes";
          file = "Catppuccin Mocha.tmTheme";
        };
      };
    };

    rbw = {
      enable = true;
      settings = {
        email = "uttarayan21@gmail.com";
        base_url = "https://pass.uttarayan.me";
        pinenttry =
          if device.isMac then pkgs.pinentry_mac else pkgs.pinentry-qt;
      };
    };
    # Let Home Manager install and manage itself.
    home-manager = { enable = true; };
  };

  fonts.fontconfig.enable = true;
  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = device.user;
    homeDirectory =
      if device.isMac then
        lib.mkForce "/Users/${device.user}"
      else
        lib.mkForce "/home/${device.user}";

    stateVersion = "23.11";

    file = {
      ".config/tmux/sessions".source = ../../tmux/sessions;
      ".config/macchina".source = ../../macchina;
      ".config/fish/themes".source = pkgs.catppuccinThemes.fish + "/themes";
      ".cache/nix-index".source = pkgs.nix-index-database;
    } // (if lazy then {
      ".config/nvim/lua".source = ../../nvim/lua;
      ".config/nvim/init.lua".source = ../../nvim/init.lua;
    } else
      { });

    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "${pkgs.nushellFull}/bin/nu";
      CARGO_TARGET_DIR = "${config.xdg.cacheHome}/cargo/target";
      BROWSER = "xdg-open";
    };
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.nix-profile/bin"
    ];
  };
}
