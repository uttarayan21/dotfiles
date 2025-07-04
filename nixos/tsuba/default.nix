{
  nixpkgs,
  devices,
  inputs,
  overlays,
  home-manager,
  nur,
  nixos-rpi,
  ...
}: (builtins.mapAttrs (
    name: device:
      nixos-rpi.lib.nixosSystemFull {
        inherit nixpkgs;
        system = device.system;
        specialArgs = {
          inherit device;
          nixos-raspberrypi = inputs.nixos-raspberrypi;
          stablePkgs = inputs.nixpkgs-stable.legacyPackages.${device.system};
        };
        modules = [
          {
            imports = with nixos-rpi.nixosModules; [
              nixos-raspberrypi.lib.inject-overlays
              raspberry-pi-5.base
              raspberry-pi-5.display-vc4
              raspberry-pi-5.bluetooth
              trusted-nix-caches
              nixpkgs-rpi
              nixos-raspberrypi.lib.inject-overlays-global
            ];
            networking.hostName = name;
          }
          ./configuration.nix
          ./${name}.nix
          {nixpkgs.overlays = overlays;}
          nur.modules.nixos.default
          inputs.sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          inputs.arion.nixosModules.arion
          {
            nixpkgs.config.allowUnfree = true;
          }
        ];
      }
  )
  devices)
