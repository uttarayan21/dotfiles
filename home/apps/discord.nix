{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.discord
    pkgs.vesktop
    pkgs.discord-canary
    pkgs.discord-ptb
  ];
}
