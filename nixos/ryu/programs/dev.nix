{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    dnsutils
    git
    gnumake
    python3
  ];
}
