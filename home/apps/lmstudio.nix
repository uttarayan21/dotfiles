{
  lib,
  device,
  pkgs,
  ...
}:
lib.mkIf (device.is "ryu") {
  home.packages = with pkgs; [
    (lmstudio.overrideAttrs
      (old: {
        extraPkgs = old.extraPkgs or [] ++ [pkgs.cudaPackages.cudatoolkit];
      }))
  ];
}
