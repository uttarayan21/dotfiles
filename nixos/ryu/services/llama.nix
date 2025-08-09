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
        url = "https://huggingface.co/lmstudio-community/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-MXFP4.gguf";
        sha256 = "65d06d31a3977d553cb3af137b5c26b5f1e9297a6aaa29ae7caa98788cde53ab";
      };
      # package = pkgs.ik_llama;
    };
    caddy = {
      virtualHosts."llama.ryu.darksailor.dev".extraConfig = ''
        import hetzner
        reverse_proxy localhost:${builtins.toString config.services.llama-cpp.port}
      '';
    };
  };
}
