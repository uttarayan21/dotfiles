{
  nixpkgs,
  devices,
  inputs,
  overlays,
  home-manager-stable,
  nur,
  nixos-raspberrypi,
  ...
}: (builtins.mapAttrs (
    name: device:
      nixos-raspberrypi.lib.nixosSystem {
        specialArgs =
          inputs
          // {
            inherit device;
            unstablePkgs = inputs.nixpkgs.legacyPackages.${device.system};
          };
        system = device.system;
        modules = [
          inputs.arion.nixosModules.arion
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          inputs.nix-minecraft.nixosModules.minecraft-servers
          nur.modules.nixos.default
          home-manager-stable.nixosModules.home-manager
          {
            nixpkgs.overlays = overlays;
            imports = with nixos-raspberrypi.nixosModules; [
              raspberry-pi-5.base
              raspberry-pi-5.display-vc4
              raspberry-pi-5.bluetooth
            ];
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
                ../../home
              ];
            };
          }
          ./configuration.nix
          ./services
          ./disk-config.nix
          ./${name}.nix
        ];
      }
  )
  devices)
