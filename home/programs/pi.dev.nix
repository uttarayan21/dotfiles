{pkgs, ...}: {
  home.packages = with pkgs; [
    pi-coding-agent
  ];
}
