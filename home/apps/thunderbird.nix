{pkgs, ...}: {
  programs.thunderbird = {
    enable = pkgs.stdenv.isLinux;
    profiles = {
    };
  };
}
