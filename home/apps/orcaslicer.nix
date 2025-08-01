{pkgs, ...}: {
  home.packages = with pkgs;
    lib.optionals pkgs.stdenv.isLinux [
      (pkgs.callPackage ./orcaslicer/package.nix {})
    ];
}
