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
          inherit device inputs;
          stablePkgs = inputs.nixpkgs-stable.legacyPackages.${device.system};
          lanzaboote = inputs.lanzaboote;
        };
        modules = [
          nur.modules.nixos.default
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko
          {nixpkgs.overlays = overlays;}
          home-manager.nixosModules.home-manager
          inputs.arion.nixosModules.arion
          # inputs.command-runner.nixosModules.command-runner
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.musnix.nixosModules.musnix
          inputs.nix-minecraft.nixosModules.minecraft-servers
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
              users.${device.user}.imports = [
                ../home
              ];
            };
          }
          ../sops.nix
          ./${device.name}/configuration.nix
        ];
      }
  )
  devices)
