{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    (pkgs.rpcs3.overrideAttrs (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.cudatoolkit];
      buildInputs = oldAttrs.buildInputs ++ [pkgs.cudatoolkit];
    }))
  ];
}
