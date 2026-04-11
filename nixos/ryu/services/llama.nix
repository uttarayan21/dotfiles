{pkgs, ...}: {
  # services.llama-cpp = {
  #   enable = true;
  # };
  environment.systemPackages = [
    pkgs.llama-cpp
  ];
}
