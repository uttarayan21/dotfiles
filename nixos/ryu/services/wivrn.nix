{pkgs, ...}: {
  services.wivrn = {
    enable = true;
    openFirewall = true;
    defaultRuntime = true;
    autoStart = true;
    package = pkgs.wivrn;
  };
}
