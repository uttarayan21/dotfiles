{
  pkgs,
  lib,
  config,
  ...
}: {
  sops.secrets."cloudflare/darksailor_dev_api_key" = {};
  home.packages = [
    # (pkgs.stdenv.mkDerivation {
    #   pname = "cfcli";
    #   version = "0.1.0";
    #   buildInputs = [pkgs.cloudflare-cli];
    #   nativeBuildInputs = [pkgs.makeWrapper];
    #   installPhase = ''
    #     $out/bin/cfcli \
    #       --run "export CF_API_KEY=\`cat -v ${config.sops.secrets."cloudflare/darksailor_dev_api_key".path}\`"
    #   '';
    # })
    (pkgs.writeShellScriptBin
      "cfcli"
      ''
        #!/bin/sh
        export CF_API_KEY="$(cat -v ${config.sops.secrets."cloudflare/darksailor_dev_api_key".path})"
        exec ${pkgs.cloudflare-cli}/bin/cfcli "$@"
      '')
  ];
}
