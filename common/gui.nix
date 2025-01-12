{
  pkgs,
  device,
  lib,
  ...
}:
lib.attrsets.optionalAttrs device.hasGui {
  systemd.user.services.onepassword-gui = lib.optionalAttrs pkgs.stdenv.isLinux {
    Unit = {
      Description = "1Password GUI";
      BindsTo = ["graphical-session.target"];
      After = ["graphical-session-pre.target"];
    };

    Service = {
      ExecStart = "${pkgs._1password-gui}/bin/1password";
      Restart = "always";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
  # home.file = lib.optionalAttrs device.isMac {
  #   "Applications/1Password.app".source = "${pkgs._1password-gui}/Applications/1Password.app";
  # };

  # Only for checking markdown previews
  vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      shd101wyy.markdown-preview-enhanced
      asvetliakov.vscode-neovim
    ];
  };
  home.packages = with pkgs;
    []
    ++ lib.optionals pkgs.stdenv.isLinux [
      ghostty
      (mpv-unwrapped.wrapper {mpv = mpv-unwrapped.override {sixelSupport = true;};})
      abaddon
      catppuccinThemes.gtk
      catppuccinThemes.papirus-folders
      ferdium
      gparted
      jdk
      mullvad-closest
      mullvad-vpn
      nautilus
      nextcloud-client
      polkit_gnome
      psst
      seahorse
      signal-desktop
      slack
      sony-headphones-client
      spotify
      steam-run
      via
      wl-clipboard
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
    ];
}
