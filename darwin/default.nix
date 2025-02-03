{
  devices,
  inputs,
  overlays,
  home-manager,
  nix-darwin,
  ...
}:
builtins.listToAttrs (builtins.map (device: {
    name = device.name;
    value = nix-darwin.lib.darwinSystem {
      system = device.system;
      modules = [
        {nixpkgs.overlays = overlays;}
        ./configuration.nix
        home-manager.darwinModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
              inherit device;
            };
            users.${device.user}.imports = [../common/home.nix];
          };
        }
      ];
    };
  })
  devices)
