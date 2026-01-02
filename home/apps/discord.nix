{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    pkgs.vesktop
    pkgs.discord-canary
    pkgs.discord-ptb
  ];
}
