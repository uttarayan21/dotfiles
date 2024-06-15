{
  inputs,
  config,
  pkgs,
  lib,
  device,
  ...
}: let
  hotedit = pkgs.writeShellApplication {
    name = "hotedit";
    # description = "Edit files from nix store by replacing them with a local copy";
    text = ''
      if [ "$#" -eq 0 ]; then
        echo "No arguments provided."
        exit 1
      elif [ "$#" -gt 1 ]; then
        echo "More than 1 argument provided."
        exit 1
      fi


      if [ -L "$1" ]; then
        echo "The file is a symbolic link."
        mv "$1" "$1.bak"
        cp "$1.bak" "$1"
        chmod +rw "$1"
      else
        echo "The file is not a symbolic link."
        exit 1
      fi
      exec $EDITOR "$1"
    '';
  };
in {
  imports =
    [
      inputs.nix-index-database.hmModules.nix-index
      ./wezterm.nix
      ./kitty.nix
      ./gui.nix

      ./auth.nix
      ./tmux.nix
      ./nvim.nix
      ./goread.nix
      ./ncmpcpp.nix
      ./zellij.nix
      ../modules
    ]
    ++ lib.optionals device.isLinux [../linux]
    # ++ lib.optionals.device.isMac [../macos]
    ++ lib.optionals device.isServer [../server];

  home.packages = with pkgs;
    [
      spotify-player

      sd
      go
      pandoc
      aichat
      nodejs
      sqls
      vcpkg
      gh
      just
      yarn
      rustup
      clang
      cmake
      alejandra
      pkg-config
      devenv
      sleek
      ra-multiplex
      d2
      jujutsu
      # openapi-tui

      # Misc
      qmk
      # bitwarden-cli
      p7zip
      yt-dlp
      spotdl
      picat
      davis
      gnupg
      gpg-tui

      file
      jq
      tldr
      bottom
      macchina
      ripgrep
      fd
      dust
      cachix
      fzf
      (nerdfonts.override {fonts = ["FiraCode" "Hasklig" "NerdFontsSymbolsOnly"];})
      monaspace
      hasklig
      pfetch-rs
      hotedit
      (mpv-unwrapped.wrapper {mpv = mpv-unwrapped.override {sixelSupport = true;};})
    ]
    ++ lib.optionals device.isLinux [
      rr
      sbctl
      gptfdisk
      dig
      usbutils
      handlr-regex
      handlr-xdg
      lsof
      ncpamixer
    ]
    ++ lib.optionals device.isMac [];

  xdg.enable = true;
  xdg.userDirs = {
    enable = device.isLinux;
    music = "${config.home.homeDirectory}/Nextcloud/Music";
  };

  programs = {
    sketchybar.enable = device.isMac;
    atuin = {
      settings = {
        auto_sync = true;
        sync_frequency = "1m";
        sync_address = "https://atuin.darksailor.dev";
      };
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    thefuck = {
      enable = true;
      enableFishIntegration = true;
    };
    direnv = {
      enable = true;
      # enableFishIntegration = true; // Auto enabled
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
          esc = ["collapse_selection" "keep_primary_selection"];
        };
      };
    };
    git = {
      enable = true;
      userName = "uttarayan21";
      userEmail = "email@uttarayan.me";
      extraConfig = {
        color.ui = true;
        core.editor = "nvim";
        core.pager = "${pkgs.delta}/bin/delta";
        interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
        delta.navigate = true;
        merge.conflictStyle = "diff3";
        diff.colorMoved = "default";
        push.autoSetupRemote = true;
      };
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
        j = "just --choose";
        # t = "zellij a -c --index 0";
        t = "tmux";
      };
      shellAliases = {
        g = "git";
        kmpv = "mpv --vo-kitty-use-shm=yes --vo=kitty --really-quiet";
        smpv = "mpv --vo-sixel-buffered=yes --vo=sixel --profile=sw-fast";
      };
      shellInit = ''
        set fish_greeting
        yes | fish_config theme save "Catppuccin Mocha"
      '';
      interactiveShellInit = ''
        ${pkgs.spotify-player}/bin/spotify_player generate fish | source
        ${pkgs.pfetch-rs}/bin/pfetch
        function _aichat_fish
            set -l _old (commandline)
            if test -n $_old
                echo -n "⌛"
                commandline -f repaint
                commandline (aichat -e $_old)
            end
        end
        bind \co _aichat_fish
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
      package = pkgs.nushell;
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
      settings = let
        flavour = "mocha"; # Replace with your preferred palette
      in
        {
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
        }
        // builtins.fromTOML (builtins.readFile
          (pkgs.catppuccinThemes.starship + /palettes/${flavour}.toml));
    };
    eza = {
      enable = true;
      # enableAliases = true;
      git = true;
      icons = true;
    };
    # carapace = {
    #   # enable = true;
    #   # enableFishIntegration = true;
    #   enableNushellIntegration = true;
    # };
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
      theme = builtins.fromTOML (builtins.readFile "${pkgs.catppuccinThemes.yazi}/themes/mocha.toml");
    };
    bat = {
      enable = true;
      config = {theme = "catppuccin";};
      themes = {
        catppuccin = {
          src = "${pkgs.catppuccinThemes.bat}/themes";
          file = "Catppuccin Mocha.tmTheme";
        };
      };
      extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch];
    };

    rbw = {
      enable = true;
      settings = {
        email = "uttarayan21@gmail.com";
        base_url = "https://pass.uttarayan.me";
        pinentry =
          if device.isMac
          then pkgs.pinentry_mac
          # then pkgs.pinentry-curses
          else pkgs.pinentry-gnome3;
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

    home-manager = {enable = true;};
  };

  fonts.fontconfig.enable = true;

  home = {
    username = device.user;
    homeDirectory =
      if device.isMac
      then lib.mkForce "/Users/${device.user}"
      else lib.mkForce "/home/${device.user}";

    stateVersion = "23.11";

    file = {
      ".config/fish/themes".source = pkgs.catppuccinThemes.fish + "/themes";
      ".cargo/config.toml".text =
        /*
        toml
        */
        ''
          [alias]
          lldb = ["with", "rust-lldb", "--"]
          t = ["nextest", "run"]

          [net]
          git-fetch-with-cli = true

          # [target.aarch64-apple-darwin]
          # linker = "clang"
          # rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]

          [registries.catscii]
          index = "https://git.shipyard.rs/catscii/crate-index.git"

          [http]
          user-agent = "shipyard J0/QFq2Sa5y6nTxJQAb8t+e/3qLSub1/sa3zn0leZv6LKG/zmQcoikT9U3xPwbzp8hQ="
        '';
    };

    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "${pkgs.fish}/bin/fish";
      CARGO_TARGET_DIR = "${config.xdg.cacheHome}/cargo/target";
      BROWSER =
        if device.isMac
        then "open"
        else "xdg-open";
    };
    sessionPath = ["${config.home.homeDirectory}/.cargo/bin"];
  };
}
