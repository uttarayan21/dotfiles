{
  devices,
  inputs,
  overlays,
  home-manager,
  nix-darwin,
  ...
}: (builtins.mapAttrs (
    name: device:
      nix-darwin.lib.darwinSystem {
        system = device.system;
        modules = [
          {nixpkgs.overlays = overlays;}
          ./${device.name}/configuration.nix
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
              users.${device.user}.imports = [../home];
            };
          }
        ];
      }
  )
  devices)
