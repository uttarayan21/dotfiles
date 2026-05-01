{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    umu-launcher
  ];
}
