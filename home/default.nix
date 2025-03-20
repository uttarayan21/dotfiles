{
  inputs,
  config,
  pkgs,
  lib,
  device,
  ...
}: {
  imports =
    [
      inputs.nix-index-database.hmModules.nix-index
      ../modules
      ./auth.nix
      ./programs
      ./scripts.nix
      ./services
    ]
    ++ lib.optionals device.isLinux [./linux]
    ++ lib.optionals device.hasGui [./gui-programs ./apps];

  # ++ lib.optionals.device.isDarwin [./macos];

  xdg.enable = true;
  xdg.userDirs = {
    enable = device.isLinux;
    # music = "${config.home.homeDirectory}/Nextcloud/Music";
  };

  programs = {
    home-manager = {enable = true;};
  };

  fonts.fontconfig.enable = true;

  home = {
    username = device.user;
    homeDirectory =
      if device.isDarwin
      then lib.mkForce "/Users/${device.user}"
      else lib.mkForce "/home/${device.user}";

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

          [registries.catscii]
          index = "https://git.shipyard.rs/catscii/crate-index.git"

          [http]
          user-agent = "shipyard J0/QFq2Sa5y6nTxJQAb8t+e/3qLSub1/sa3zn0leZv6LKG/zmQcoikT9U3xPwbzp8hQ="
        '';
    };

    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "${pkgs.bash}/bin/bash";
      CARGO_TARGET_DIR = "${config.xdg.cacheHome}/cargo/target";
      BROWSER =
        if device.isDarwin
        then "open"
        else "xdg-open";
    };
    sessionPath = ["${config.home.homeDirectory}/.cargo/bin" "${config.home.homeDirectory}/.local/bin"];

    stateVersion = "23.11";
  };
}
