{pkgs, ...}: {
  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    config.enable = true;
    config.json = {
      encoder = {
        encoder = "nvenc";
        codec = "av1";
      };
    };
    # defaultRuntime = true;
    steam.importOXRRuntimes = true;
    highPriority = true;
    # package = pkgs.wivrn-nightly;
  };
}
