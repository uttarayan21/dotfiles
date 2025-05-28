{pkgs, ...}: {
  home.packages = with pkgs;
    lib.optionals pkgs.stdenv.isLinux [
      (orca-slicer.overrideAttrs (oldAttrs: {
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.cudatoolkit];
        buildInputs = oldAttrs.buildInputs ++ [pkgs.cudatoolkit];
      }))
      # (pkgs.callPackage ./orca.nix {})
    ];
}
