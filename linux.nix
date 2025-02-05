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
  imports = [
    ./kitty.nix
    ./firefox.nix
    ./ghostty.nix
    ./cursor.nix
    ./vscodium.nix
    ./wezterm.nix
  ];

  home.packages = with pkgs;
    []
    ++ lib.optionals pkgs.stdenv.isLinux [
      discord
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
      zed-editor
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
    ];
}
