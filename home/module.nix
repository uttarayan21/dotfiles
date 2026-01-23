{
  device,
  inputs,
  pkgs,
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
      cratesNix = inputs.crates-nix.mkLib {inherit pkgs;};
    };
    users.${device.user}.imports = [
      inputs.nixvim.homeModules.nixvim
      ./.
    ];
  };
}
