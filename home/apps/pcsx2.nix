{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    (pkgs.pcsx2.overrideAttrs (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.cudatoolkit];
      buildInputs = oldAttrs.buildInputs ++ [pkgs.cudatoolkit];
    }))
  ];
}
