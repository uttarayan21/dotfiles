{
  devices,
  inputs,
  nix-darwin,
  overlays,
  ...
}: (builtins.mapAttrs (
    name: device:
      nix-darwin.lib.darwinSystem {
        system = device.system;
        specialArgs = {
          inherit device inputs;
          stablePkgs = inputs.nixpkgs-stable.legacyPackages.${device.system};
        };
        modules = [
          inputs.home-manager.darwinModules.home-manager
          inputs.sops-nix.darwinModules.sops
          inputs.stylix.darwinModules.stylix

          ./${device.name}/configuration.nix
          ../home/module.nix
          {nixpkgs.overlays = overlays;}
          ../sops.nix
          ../stylix.nix
        ];
      }
  )
  devices)
