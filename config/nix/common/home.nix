{
  config,
  pkgs,
  lib,
  device,
  inputs,
  ...
}: let
  start-tmux = (import ../scripts/start-tmux.nix) pkgs;
in
  # https://mipmip.github.io/home-manager-option-search/
  {
    imports = [
      # Include the results of the hardware scan.
      ./tmux.nix
      ./wezterm.nix
      ../linux/hyprland.nix
      ./firefox.nix
      inputs.anyrun.nixosModules.home-manager
    ];

    home.packages = with pkgs; [
      nodejs
      nix-index
      yubikey-personalization
      macchina
      ripgrep
      fd
      alejandra
      dust
      eza
      cachix
      rustup
      cmake
      fzf
      anyrun
      clang
      ncpamixer
      neovim-nightly
      yubikey-agent
      (nerdfonts.override {fonts = ["Hasklig"];})
      mpv
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

    xdg.enable = true;

    programs = {
      git = {
        enable = true;
        userName = "uttarayan21";
        userEmail = "email@uttarayan.me";
      };
      nix-index.enableFishIntegration = true;
      fish = {
        enable = true;
        shellAbbrs = {
          vim = "nvim";
          vi = "nvim";
          nv = "nvim";
          g = "git";
          cd = "z";
          ls = "exa";
          t = "${start-tmux}";
        };
        shellInit = ''
          set fish_greeting
        '';
        interactiveShellInit = ''
          ${pkgs.macchina.outPath}/bin/macchina
        '';
      };

      nushell = {
        enable = true;
        shellAliases = {
          "cd" = "z";
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
      fzf = {
        enable = true;
        package = pkgs.fzf;
        enableFishIntegration = true;
        tmux.enableShellIntegration = true;
      };
      # keychain = {
      #   enable = pkgs.isLinux;
      #   keys = [ "id_ed25519" ];
      #   enableFishIntegration = true;
      #   enableNushellIntegration = true;
      # };
      yazi = {
        enable = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };
      foot = {
        enable = pkgs.stdenv.isLinux;
        server.enable = true;
        settings = {
          main = {
            shell = "${pkgs.fish.outPath}/bin/fish";
            font = "Hasklug Nerd Font Mono:size=13";
            initial-window-size-pixels = "1440x800";
          };
          colors = {
            foreground = "f8f8f2";
            background = 000000;
            alpha = 0.8;

            "136" = "af8700";

            regular0 = "21222c";
            regular1 = "ff5555";
            regular2 = "50fa7b";
            regular3 = "f1fa8c";
            regular4 = "bd93f9";
            regular5 = "ff79c6";
            regular6 = "8be9fd";
            regular7 = "f8f8f2";

            bright0 = "6272a4";
            bright1 = "ff6e6e";
            bright2 = "69ff94";
            bright3 = "ffffa5";
            bright4 = "d6acff";
            bright5 = "ff92df";
            bright6 = "a4ffff";
            bright7 = "ffffff";
          };
        };
      };

      anyrun = {
        enable = true;
        config = {
          plugins = with inputs.anyrun.packages.${pkgs.system}; [
            rink
            applications
            websearch
            shell
            translate
            symbols
          ];
          x = {fraction = 0.5;};
          y = {fraction = 0.3;};
          height = {absolute = 0;};
          width = {absolute = 1000;};
          showResultsImmediately = true;
          layer = "overlay";
        };

        extraConfigFiles = {
          "shell.ron".text = ''
            Config(
                prefix: "",
                shell: None,
            )
          '';
          "handlr.ron".text = ''
            Config(
                prefix: "",
                log: None,
            )
          '';
          "websearch.ron".text = ''
            Config(
                prefix: "?"
                engines: [Google, DuckDuckGo]
            )
          '';
        };

        extraCss = ''
          window {
              color: #ffffff;
              background-color: rgba(15, 15, 15, .2);
              border-color: #000000;
          }

          entry {
              color: #ffffff;
              background-color: rgba(40, 40, 40, .98);
              padding: 14px;
              font-size: 30px;
              border-color: #000000;
              border-radius: 10px;
          }

          #plugin {
              color: #efefef;
              border-color: #000000;
              border-color: #000000;
              border-radius: 5px;
          }

          #main {
              color: #efefef;
              border-color: #000000;
              border-color: #000000;
              border-radius: 5px;
          }
        '';
      };

      # Let Home Manager install and manage itself.
      home-manager = {
        enable = true;
      };
    };

    fonts.fontconfig.enable = true;
    home = {
      # Home Manager needs a bit of information about you and the paths it should
      # manage.
      username = device.user;
      homeDirectory =
        if device.isMac
        then lib.mkForce "/Users/${device.user}"
        else lib.mkForce "/home/${device.user}";

      stateVersion = "23.11";

      file = {
        ".config/tmux/sessions".source = ../../tmux/sessions;
        ".config/nvim/lua".source = ../../nvim/lua;
        ".config/nvim/init.lua".source = ../../nvim/init.lua;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
      };

      sessionVariables = {
        EDITOR = "nvim";
        SHELL = "${pkgs.nushellFull}/bin/nu";
        CARGO_TARGET_DIR = "${config.xdg.cacheHome}/cargo/target";
      };
      sessionPath = [
        "${config.home.homeDirectory}/.local/bin"
        "${config.home.homeDirectory}/.nix-profile/bin"
      ];
    };
  }
