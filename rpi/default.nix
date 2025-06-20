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
          stablePkgs = inputs.nixpkgs-stable.legacyPackages.${device.system};
        };
        modules = [
          {
            imports = with nixos-rpi.nixosModules; [
              raspberry-pi-5.base
              raspberry-pi-5.display-vc4
              raspberry-pi-5.bluetooth
            ];
          }
          {nixpkgs.overlays = overlays;}
          nur.modules.nixos.default
          inputs.sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.arion.nixosModules.arion
          ./configuration.nix
          {
            nixpkgs.config.allowUnfree = true;
            # home-manager = {
            #   backupFileExtension = "bak";
            #   useGlobalPkgs = true;
            #   useUserPackages = true;
            #   extraSpecialArgs = {
            #     inherit inputs;
            #     inherit device;
            #     stablePkgs = inputs.nixpkgs-stable.legacyPackages.${device.system};
            #   };
            #   users.${device.user}.imports = [./home];
            # };
          }
        ];
      }
  )
  devices)
