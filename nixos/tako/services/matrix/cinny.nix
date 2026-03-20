{
  pkgs,
  config,
  inputs,
  ...
}: let
  base_domain = "darksailor.dev";
  cinnyConfig = builtins.toJSON {
    defaultHomeserver = 0;
    homeserverList = ["darksailor.dev" "matrix.org"];
    allowCustomHomeservers = false;
    hashRouter = {
      enabled = true;
      basename = "/";
    };
  };
  cinnyConfigFile = pkgs.writeText "cinny-config.json" cinnyConfig;
  cinny = with pkgs;
    buildNpmPackage rec {
      pname = "cinny-unwrapped";
      version = "4.11.1";
      src = inputs.cinny;

      nodejs = nodejs_22;

      npmDepsHash = "sha256-MTx0MoXa4+sWagrUDMWzEK2ofRqcZHbSyPiO3PGz+JM=";

      nativeBuildInputs = [
        python3
        pkg-config
      ];

      buildInputs =
        [
          pixman
          cairo
          pango
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [giflib];

      installPhase = ''
        runHook preInstall

        cp -r dist $out

        runHook postInstall
      '';
    };
in {
  services.caddy.virtualHosts = {
    "matrix.${base_domain}".extraConfig = ''
      handle /_matrix/* {
        reverse_proxy /_matrix/* localhost:${toString (builtins.elemAt config.services.matrix-tuwunel.settings.global.port 0)}
      }
      handle_path /config.json  {
        file_server
        root ${cinnyConfigFile}
      }
      handle {
          root * ${cinny}
          try_files {path} /index.html
          file_server
      }
    '';
  };
}
