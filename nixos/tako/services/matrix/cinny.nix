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
      version = "4.10.5";

      # src = fetchFromGitHub {
      #   owner = "cinnyapp";
      #   repo = "cinny";
      #   rev = "dev";
      #   # tag = "v${version}";
      #   hash = "sha256-2qxmlj4IK6twDh27R6qMJDmYSfsWoofVGuRHxSP72f0=";
      # };
      src = inputs.cinny;

      nodejs = nodejs_22;

      npmDepsHash = "sha256-qyQ0SXkPSUES/tavKzPra0Q+ZnU9qHvkTC1JgAjL0o8=";

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
