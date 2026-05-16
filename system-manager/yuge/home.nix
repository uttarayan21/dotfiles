{
  device,
  inputs,
  lib,
  ...
}: {
  users.users.${device.user} = {
    isNormalUser = true;
    home = device.home;
    group = device.user;
    uid = device.uid;
  };
  users.groups.${device.user}.gid = device.gid;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    backupFileExtension = "bak";
    extraSpecialArgs = {inherit device inputs;};
    users.${device.user} = {
      home = {
        username = device.user;
        homeDirectory = lib.mkForce device.home;
        stateVersion = "24.05";
        packages = [
          inputs.slo.packages.${device.system}.default
        ];
      };
      programs.home-manager.enable = true;
    };
  };
}
