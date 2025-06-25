{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    (pkgs.shadps4.overrideAttrs
      (oldAttrs: {
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.cudatoolkit];
        buildInputs = oldAttrs.buildInputs ++ [pkgs.cudatoolkit];
      }))
  ];
}
