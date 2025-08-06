{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  services = {
    llama-cpp = {
      enable = true;
      model = pkgs.fetchurl {
        url = "https://huggingface.co/unsloth/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-F16.gguf";
        sha256 = "b93a63c42fc2432396b56031bb1a4aa5f598af1de369de397a900888032cad64";
      };
      # package = pkgs.llama-cpp.overrideAttrs (old: {
      #   src = inputs.ik_llama;
      #   version = "5995";
      # });
    };
    # caddy = {
    #   virtualHosts."llama.ryu.darksailor.dev".extraConfig = ''
    #     import hetzner
    #     reverse_proxy localhost:${builtins.toString config.services.llama-cpp.port}
    #   '';
    # };
  };
}
