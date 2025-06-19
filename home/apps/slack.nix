{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    (pkgs.slack.overrideAttrs (old: {
      installPhase =
        old.installPhase
        + ''
          rm $out/bin/slack

          makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
          --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
          --add-flags "--enable-features=WebRTCPipeWireCapturer %U"
        '';
    }))
  ];
}
