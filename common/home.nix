{ inputs, config, pkgs, lib, device, ... }: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./tmux.nix
    ./wezterm.nix
    ./nvim.nix
    ./goread.nix
    ./ncmpcpp.nix
    # ./neomutt.nix
  ] ++ lib.optionals device.isLinux [ ../linux ];

  home.packages = with pkgs;
    [
      go
      p7zip
      picat
      spotdl
      davis
      pandoc
      gnupg
      gpg-tui
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
      nil
      pkg-config
      lua-language-server
      (nerdfonts.override { fonts = [ "Hasklig" ]; })
      pfetch-rs
      psst
    ] ++ lib.optionals device.isLinux [
      mpv
      catppuccinThemes.gtk
      catppuccinThemes.papirus-folders
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
      usbutils
      handlr-regex
      handlr-xdg
      webcord-vencord
      spotify
      lsof
      wl-clipboard
      ncpamixer
    ] ++ lib.optionals device.isMac [ ];

  xdg.enable = true;
  xdg.userDirs = {
    enable = device.isLinux;
    music = "${config.home.homeDirectory}/Nextcloud/Music";
  };

  programs = {
    direnv = {
      enable = true;
      # enableFishIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
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
          # Check https://starship.rs/config/#prompt
          format = "$all$character";
          palette = "catppuccin_${flavour}";
          character = {
            success_symbol = "[[OK](bold green) ❯](maroon)";
            error_symbol = "[❯](red)";
            vimcmd_symbol = "[❮](green)";
          };
          directory = {
            truncation_length = 4;
            style = "bold lavender";
          };
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
      extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
    };

    rbw = {
      enable = true;
      settings = {
        email = "uttarayan21@gmail.com";
        base_url = "https://pass.uttarayan.me";
        pinentry =
          if device.isMac then pkgs.pinentry_mac else pkgs.pinentry-qt;
      };
    };

    # Only for checking markdown previews
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        shd101wyy.markdown-preview-enhanced
        asvetliakov.vscode-neovim
      ];
    };

    home-manager = { enable = true; };
  };

  fonts.fontconfig.enable = true;

  home = {
    username = device.user;
    homeDirectory =
      if device.isMac then
        lib.mkForce "/Users/${device.user}"
      else
        lib.mkForce "/home/${device.user}";

    stateVersion = "23.11";

    file = {
      ".config/fish/themes".source = pkgs.catppuccinThemes.fish + "/themes";
    };

    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "${pkgs.nushellFull}/bin/nu";
      CARGO_TARGET_DIR = "${config.xdg.cacheHome}/cargo/target";
      BROWSER = if device.isMac then "open" else "xdg-open";
    };
    sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];
  };
}

