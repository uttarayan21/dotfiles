{
  nixpkgs,
  devices,
  inputs,
  overlays,
  home-manager,
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
          inputs.disko.nixosModules.disko
          nur.modules.nixos.default
          inputs.sops-nix.nixosModules.sops
          {
            nixpkgs.overlays = overlays;
            imports = with nixos-raspberrypi.nixosModules; [
              raspberry-pi-5.base
              raspberry-pi-5.display-vc4
              raspberry-pi-5.bluetooth
            ];
          }
          ./configuration.nix
          ./services
          ./disk-config.nix
          ./${name}.nix
        ];
      }
  )
  devices)
