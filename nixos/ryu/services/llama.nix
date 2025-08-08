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
      port = 11435;
      model = pkgs.fetchurl {
        url = "https://huggingface.co/unsloth/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-F16.gguf";
        # sha256 = "sha256-vE1SpG4diQiP88u0viGnyZ8LtotTUU19UGecnwfjOkE=";
        sha256 = "sha256-kpeennNi4+MbFTuINkRi8CI9srQj7Q0eyKysG/4cbmI=";
      };
      package = pkgs.ik_llama;
    };
    # caddy = {
    #   virtualHosts."llama.ryu.darksailor.dev".extraConfig = ''
    #     import hetzner
    #     reverse_proxy localhost:${builtins.toString config.services.llama-cpp.port}
    #   '';
    # };
  };
}
