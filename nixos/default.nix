{
  nixpkgs,
  devices,
  inputs,
  overlays,
  home-manager,
  nur,
  ...
}: (builtins.mapAttrs (
    name: device:
      nixpkgs.lib.nixosSystem {
        system = device.system;
        specialArgs = {
          inherit device;
          stablePkgs = inputs.nixpkgs-stable.legacyPackages.${device.system};
          lanzaboote = inputs.lanzaboote;
        };
        modules = [
          nur.modules.nixos.default
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko
          {nixpkgs.overlays = overlays;}
          ./${device.name}/configuration.nix
          home-manager.nixosModules.home-manager
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.musnix.nixosModules.musnix
          inputs.arion.nixosModules.arion
          {
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
              users.${device.user}.imports = [../home];
            };
          }
        ];
      }
  )
  devices)
