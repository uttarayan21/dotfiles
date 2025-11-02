{
  device,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit device;
      stablePkgs = inputs.nixpkgs-stable.legacyPackages.${device.system};
    };
    users.${device.user}.imports = [
      inputs.nixvim.homeModules.nixvim
      ./.
    ];
  };
}
