{
  pkgs,
  config,
  inputs,
  ...
}: {
  services = {
    llama-cpp = {
      enable = false;
      port = 11345;
      # model = "/nix/store/ch6z9di3l0k54ad29pzv8k3zv47q30d1-Qwen3-Coder-30B-A3B-Instruct-Q4_K_M.gguf";
      model = pkgs.fetchurl {
        # url = "https://huggingface.co/lmstudio-community/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-MXFP4.gguf";
        # sha256 = "65d06d31a3977d553cb3af137b5c26b5f1e9297a6aaa29ae7caa98788cde53ab";
        url = "https://huggingface.co/lmstudio-community/Qwen3-Coder-30B-A3B-Instruct-GGUF/resolve/main/Qwen3-Coder-30B-A3B-Instruct-Q4_K_M.gguf";
        sha256 = "79ad15a5ee3caddc3f4ff0db33a14454a5a3eb503d7fa1c1e35feafc579de486";
      };
      extraFlags = [
        "-c"
        "98304"
        "--jinja"
        "--chat-template-file"
        "${../../../assets/chat.hbs}"
        # "/nix/store/4zk1p50hrzghp3jzzysz96pa64i2kmjl-promp.hbs"
      ];
      # package = inputs.llama-cpp.packages.${pkgs.system}.cuda;
    };
    caddy = {
      virtualHosts."llama.ryu.darksailor.dev".extraConfig = ''
        import cloudflare
        reverse_proxy localhost:${builtins.toString config.services.llama-cpp.port}
      '';
    };
  };
  environment.systemPackages = with pkgs; [
    llama-cpp
  ];
}
