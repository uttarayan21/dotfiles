{
  config,
  pkgs,
  device,
  lib,
  ...
}: let
  name = "shiro";
  stateDir = "/var/lib/gitea-runner/${name}";
  url = "https://git.darksailor.dev";
  labels = [
    "macos-latest:host"
    "macos-arm64:host"
    "nix-darwin:host"
  ];
  labelsStr = lib.concatStringsSep "," labels;
  labelsSorted = builtins.concatStringsSep "\n" (builtins.sort builtins.lessThan labels);

  settingsFormat = pkgs.formats.yaml {};
  configFile = settingsFormat.generate "runner-config.yaml" {};

  hostPackages = with pkgs; [
    bash
    coreutils
    curl
    gawk
    gitMinimal
    gnused
    nix
    nodejs
    wget
  ];

  runnerScript = pkgs.writeShellApplication {
    name = "gitea-runner-${name}";
    runtimeInputs = hostPackages ++ [pkgs.gitea-actions-runner];
    text = ''
      INSTANCE_DIR="${stateDir}"
      mkdir -p "$INSTANCE_DIR"
      cd "$INSTANCE_DIR"

      TOKEN_FILE="${config.sops.templates."GITEA_RUNNER_TOKEN.env".path}"
      while [ ! -f "$TOKEN_FILE" ]; do
        echo "Waiting for SOPS secrets..."
        sleep 5
      done

      # shellcheck disable=SC1090
      source "$TOKEN_FILE"

      LABELS_FILE="$INSTANCE_DIR/.labels"
      LABELS_WANTED="${labelsSorted}"
      LABELS_CURRENT="$(cat "$LABELS_FILE" 2>/dev/null || echo 0)"

      if [ ! -e "$INSTANCE_DIR/.runner" ] || [ "$LABELS_WANTED" != "$LABELS_CURRENT" ]; then
        rm -f "$INSTANCE_DIR/.runner"

        act_runner register --no-interactive \
          --instance ${lib.escapeShellArg url} \
          --token "$TOKEN" \
          --name ${lib.escapeShellArg name} \
          --labels ${lib.escapeShellArg labelsStr} \
          --config ${configFile}

        echo "$LABELS_WANTED" > "$LABELS_FILE"
      fi

      exec act_runner daemon --config ${configFile}
    '';
  };
in {
  sops = {
    secrets."gitea/registration" = {};
    templates."GITEA_RUNNER_TOKEN.env".content = ''
      TOKEN=${config.sops.placeholder."gitea/registration"}
    '';
  };

  launchd.daemons.gitea-runner = {
    command = "${lib.getExe runnerScript}";
    serviceConfig = {
      Label = "dev.darksailor.gitea-runner";
      RunAtLoad = true;
      KeepAlive = true;
      UserName = device.user;
      StandardOutPath = "/var/log/gitea-runner.log";
      StandardErrorPath = "/var/log/gitea-runner.error.log";
    };
  };
}
