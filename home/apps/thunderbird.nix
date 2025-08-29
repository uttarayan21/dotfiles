{
  pkgs,
  stablePkgs,
  ...
}: {
  programs.thunderbird = {
    enable = pkgs.stdenv.isLinux;
    profiles = {};
    package = stablePkgs.thunderbird;
  };
}
