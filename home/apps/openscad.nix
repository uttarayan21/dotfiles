{
  pkgs,
  device,
  ...
}: {
  home.packages = [
    (pkgs.openscad-unstable.overrideAttrs
      (_: {
        doCheck = false;
      }))
  ];
}
