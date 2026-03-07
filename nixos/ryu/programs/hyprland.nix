{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    xhost
  ];
}
