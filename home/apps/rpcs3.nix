{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    ((pkgs.rpcs3.override {
        opencv =
          (pkgs.opencv.override {
            enableCuda = true;
          })
            .overrideAttrs (oldAttrs: {
            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.cudatoolkit];
            buildInputs = oldAttrs.buildInputs ++ [pkgs.cudatoolkit];
          });
      })
            .overrideAttrs (oldAttrs: {
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.cudatoolkit];
        buildInputs = oldAttrs.buildInputs ++ [pkgs.cudatoolkit];
      }))
  ];
}
