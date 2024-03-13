{ inputs, config, pkgs, lib, device, ... }: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./tmux.nix
    ./wezterm.nix
    ./nvim.nix
  ] ++ lib.optionals device.isLinux [ ../linux ];

  home.packages = with pkgs;
    [
      pandoc
      gnupg
      gpg-tui
      ngrok
      slack
      yarn
      spotify-player
      qmk
      nodejs
      neovide
      sqls
      vcpkg
      file
      yt-dlp
      gh
      just
      jq
      tldr
      bottom
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
      pfetch-rs
    ] ++ lib.optionals device.isLinux [
      mpv
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

  xdg.enable = true;

  programs = {
    nix-index-database.comma.enable = true;
    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
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
        cat = "bat";
        t = "tmux";
      };
      shellAliases = { g = "git"; };
      shellInit = ''
        set fish_greeting
        yes | fish_config theme save "Catppuccin Mocha"
      '';
      interactiveShellInit = ''
        ${pkgs.spotify-player}/bin/spotify_player generate fish | source
        ${pkgs.pfetch-rs}/bin/pfetch
      '';
    };

    nushell = {
      enable = true;
      shellAliases = {
        cd = "z";
        yy = "yazi";
        nv = "neovide";
        cat = "bat";
      };
      extraConfig = ''
        ${pkgs.pfetch-rs}/bin/pfetch
      '';
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
      # ".config/tmux/sessions".source = ../../tmux/sessions;
      # ".config/macchina".source = ../../macchina;
      ".config/fish/themes".source = pkgs.catppuccinThemes.fish + "/themes";
      # ".cache/nix-index".source = pkgs.nix-index-database;
    };

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
