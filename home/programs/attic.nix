{
  pkgs,
  lib,
  config,
  ...
}: let
  attic-unwrapped = pkgs.attic-client.overrideAttrs (oldAttrs: {
    patches =
      (oldAttrs.patches or [])
      ++ [
        # PR #309: Add environment variable support for login
        # https://github.com/zhaofengli/attic/pull/309
        (pkgs.fetchpatch {
          url = "https://github.com/zhaofengli/attic/pull/309.patch";
          hash = "sha256-mDoxA+e2bBZDvERp03SyYvkEdtH/bfWtZqKZv0uCS0M=";
        })
      ];
  });
in {
  sops.secrets."attic/token" = {};
  home.packages = [
    (pkgs.stdenv.mkDerivation {
      pname = "attic-client";
      version = "0.1.0";
      src = attic-unwrapped;
      buildInputs = [];
      nativeBuildInputs = [pkgs.makeWrapper];
      installPhase = ''
        install -Dm755 $src/bin/attic $out/bin/attic
        wrapProgram $out/bin/attic \
          --run "export ATTIC_LOGIN_TOKEN=\`cat -v ${config.sops.secrets."attic/token".path}\`"
      '';
    })
  ];
}
