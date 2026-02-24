{
  pkgs,
  config,
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
      version = "4.10.5";

      src = fetchFromGitHub {
        owner = "cinnyapp";
        repo = "cinny";
        tag = "v${version}";
        hash = "sha256-Napy3AcsLRDZPcBh3oq1U30FNtvoNtob0+AZtZSvcbM=";
      };

      nodejs = nodejs_22;

      npmDepsHash = "sha256-2Lrd0jAwAH6HkwLHyivqwaEhcpFAIALuno+MchSIfxo=";

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
