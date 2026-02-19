{
  inputs,
  config,
  pkgs,
  lib,
  device,
  ...
}: {
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ../modules
    ./apps
    ./auth.nix
    ./programs
    ./scripts.nix
    ./services
    ./accounts
    ./fonts.nix
  ];

  xdg.enable = true;
  xdg.userDirs = {
    enable = device.isLinux;
  };

  programs = {
    home-manager = {
      enable = true;
    };
    man.generateCaches = true;
  };

  fonts.fontconfig.enable = true;

  home = {
    username = device.user;
    homeDirectory = lib.mkForce device.home;

    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "${pkgs.bash}/bin/bash";
      CARGO_TARGET_DIR = "${config.xdg.cacheHome}/cargo/target";
      BROWSER =
        if device.isDarwin
        then "open"
        else "xdg-open";
    };
    sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.local/bin"
    ];

    stateVersion = "23.11";
  };
}
