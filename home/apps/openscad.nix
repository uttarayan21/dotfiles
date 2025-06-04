{
  pkgs,
  device,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    (pkgs.openscad-unstable.overrideAttrs
      (_: {
        doCheck = false;
      }))
  ];
}
