{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.nixify.packages.${pkgs.system}.default
  ];
}
