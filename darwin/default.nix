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
        specialArgs = {
          inherit device;
        };
        modules = [
          {nixpkgs.overlays = overlays;}
          ./${device.name}/configuration.nix
          inputs.sops-nix.darwinModules.sops
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
