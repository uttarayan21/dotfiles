{
  pkgs,
  lib,
  config,
  ...
}: {
  nixpkgs.config.permittedInsecurePackages = [
    "openclaw-2026.2.26"
  ];
  environment.systemPackages = with pkgs; [
    ollama
    openclaw
  ];
  launchd.agents.openclaw = {
    # enable = true;
    script = ''
      ${lib.getExe pkgs.ollama} launch openclaw --model qwen3.5:9b
    '';
    # config = {
    #   Label = "com.openclaw";
    #   ProgramArguments = [
    #     "${lib.getExe pkgs.ollama}"
    #     "launch"
    #     "openclaw"
    #     "--model"
    #     "qwen3.5:9b"
    #   ];
    #   RunAtLoad = true;
    #   KeepAlive = false;
    #   # StandardOutPath = "${config.home.homeDirectory}/Library/Logs/openclaw.log";
    #   # StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/openclaw.error.log";
    # };
  };
}
