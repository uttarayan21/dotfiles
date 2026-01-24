{pkgs, ...}: let
  version = "2026.01.21-11273a4";
  hytale-launcher = pkgs.fetchzip {
    url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-${version}.zip";
    sha256 = "sha256-PPdYmLxAVyqSkhulZXLcaEuhofCHZ4JcDJXIQ+lBhFg=";
  };
in {
  environment.systemPackages = with pkgs; [
    (pkgs.buildFHSEnv {
      pname = "hytale";
      inherit version;
      targetPkgs = p:
        with p; [
          # Launcher
          libsoup_3
          gdk-pixbuf
          glib
          gtk3
          webkitgtk_4_1

          # Game
          alsa-lib
          icu
          libGL
          openssl
          udev
          xorg.libX11
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXi
        ];
      runScript = "${hytale-launcher}/hytale-launcher";
    })
  ];
}
