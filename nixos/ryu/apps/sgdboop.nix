{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    sgdboop
  ];
}
