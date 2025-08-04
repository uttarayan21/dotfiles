{
  inputs,
  pkgs,
  device,
  lib,
  ...
}: let
  pkgs' = pkgs.applyPatches {
    name = "nixpkgs-orcaslicer-430171";
    src = inputs.nixpkgs;
    patches = [../../patches/430171.patch];
  };
  pkgsPatched = import pkgs' {system = device.system;};
in {
  home.packages = lib.mkIf device.isLinux [
    pkgsPatched.orca-slicer
  ];
}
