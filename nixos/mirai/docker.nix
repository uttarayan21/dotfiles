{
  config,
  lib,
  pkgs,
  ...
}: {
  # virtualisation = {
  #   docker.enable = true;
  #   podman.enable = true;
  #   oci-containers = {
  #     backend = "podman";
  #     containers.homeassistant = {
  #       volumes = ["home-assistant:/config"];
  #       environment.TZ = "Asia/Kolkata";
  #       image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
  #       extraOptions = [
  #         "--network=ha-net"
  #       ];
  #     };
  #   };
  # };
  # networking.firewall.allowedTCPPorts = [8123];
  # environment.systemPackages = with pkgs; [
  #   docker
  #   podman
  # ];
  # services.caddy = {
  #   enable = true;
  #   virtualHosts."home.darksailor.dev".extraConfig = ''
  #     reverse_proxy localhost:8123
  #   '';
  # };
  # containers.llama = {
  #   autoStart = true;
  #   privateNetwork = true;
  #   hostAddress = "192.168.100.10";
  #   localAddress = "192.168.100.11";
  #   hostAddress6 = "fc00::1";
  #   localAddress6 = "fc00::2";
  #   config = {
  #     config,
  #     pkgs,
  #     libs,
  #     ...
  #   }: {
  #     system.stateVersion = "24.11";
  #     networking = {
  #       firewall = {
  #         enable = true;
  #         allowedTCPPorts = [4000];
  #       };
  #       # Use systemd-resolved inside the container
  #       # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
  #       useHostResolvConf = lib.mkForce false;
  #     };
  #     services.resolved.enable = true;
  #     services.llama-cpp = {
  #       enable = true;
  #       host = "127.0.0.1";
  #       port = 4000;
  #       model = builtins.fetchurl {
  #         name = "qwen_2.5.1_coder_7b_instruct_gguf";
  #         sha256 = "61834b88c1a1ce5c277028a98c4a0c94a564210290992a7ba301bbef96ef8eba";
  #         url = "https://huggingface.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF/resolve/main/Qwen2.5.1-Coder-7B-Instruct-Q8_0.gguf?download=true";
  #       };
  #     };
  #   };
  # };
}
