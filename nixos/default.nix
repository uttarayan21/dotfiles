{
  devices,
  inputs,
  nixpkgs,
  overlays,
  ...
}: (builtins.mapAttrs (
    name: device:
      nixpkgs.lib.nixosSystem {
        system = device.system;
        specialArgs = {
          inherit device inputs;
          stablePkgs = inputs.nixpkgs-stable.legacyPackages.${device.system};
          masterPkgs = inputs.nixpkgs-master.legacyPackages.${device.system};
          lanzaboote = inputs.lanzaboote;
          cratesNix = inputs.crates-nix.mkLib {pkgs = nixpkgs.legacyPackages.${device.system};};
        };
        modules = [
          inputs.arion.nixosModules.arion
          inputs.disko.nixosModules.disko
          inputs.handoff.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.musnix.nixosModules.musnix
          inputs.nix-minecraft.nixosModules.minecraft-servers
          inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
          inputs.nur.modules.nixos.default
          inputs.sops-nix.nixosModules.sops
          inputs.stylix.nixosModules.stylix

          ./${device.name}/configuration.nix
          ../home/module.nix
          {nixpkgs.overlays = overlays;}
          ../sops.nix
          ../stylix.nix
        ];
      }
  )
  devices)
