{ config, pkgs, ... }:
# https://mipmip.github.io/home-manager-option-search/
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fs0c131y";
  home.homeDirectory = "/home/fs0c131y";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  imports = [
    # Include the results of the hardware scan.
    ./tmux.nix
    ./wezterm.nix
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
        set fish_greeting
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
        show_banner: false,
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
    keychain = {
      enable = true;
      keys = ["id_ed25519"];
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    yazi = {
        enable = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
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
    SHELL = "${pkgs.fish.outPath}/bin/fish";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
