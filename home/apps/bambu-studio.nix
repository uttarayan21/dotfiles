{pkgs, ...}: {
  home.packages = with pkgs;
    lib.optionals pkgs.stdenv.isLinux [
      # (bambu-studio.overrideAttrs (oldAttrs: {
      #   nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.cudatoolkit];
      #   buildInputs = oldAttrs.buildInputs ++ [pkgs.cudatoolkit];
      # }))
      (orca-slicer.overrideAttrs (oldAttrs: {
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.cudatoolkit];
        buildInputs = oldAttrs.buildInputs ++ [pkgs.cudatoolkit];
      }))
    ];
}
