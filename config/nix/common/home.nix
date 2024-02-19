{ config, pkgs, lib, device, ... }:
let
  start-tmux = (import ../scripts/start-tmux.nix) pkgs;
  # https://mipmip.github.io/home-manager-option-search/
in {
  imports = [
    # Include the results of the hardware scan.
    ./tmux.nix
    ./wezterm.nix
  ] ++ (if device.isLinux then [ ../linux ] else [ ]);

  home.packages = with pkgs;
    [
      htop-vim
      qmk
      nodejs
      nix-index
      macchina
      ripgrep
      fd
      nixfmt
      dust
      eza
      cachix
      rustup
      cmake
      fzf
      clang
      # neovim-nightly
      neovim
      (nerdfonts.override { fonts = [ "Hasklig" ]; })
      mpv
    ] ++ (if device.isLinux then [
      handlr-regex
      webcord-vencord
      spotify
      spotify-player
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
    ] else
      [ ]);

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
      shellAliases = { "cd" = "z"; };
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
    yazi = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    # Let Home Manager install and manage itself.
    home-manager = { enable = true; };
  };

  fonts.fontconfig.enable = true;
  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = device.user;
    homeDirectory = if device.isMac then
      lib.mkForce "/Users/${device.user}"
    else
      lib.mkForce "/home/${device.user}";

    stateVersion = "23.11";

    file = {
      ".config/tmux/sessions".source = ../../tmux/sessions;
      ".config/nvim/lua".source = ../../nvim/lua;
      ".config/nvim/init.lua".source = ../../nvim/init.lua;
      ".config/macchina".source = ../../macchina;

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
