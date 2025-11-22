{pkgs, ...}: {
  home.packages = with pkgs; [
    tsukimi
  ];
}
