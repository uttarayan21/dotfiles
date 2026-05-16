{
  devices,
  inputs,
  system-manager,
  ...
}: (builtins.mapAttrs (
    name: device:
      system-manager.lib.makeSystemConfig {
        modules = [
          {
            nixpkgs.hostPlatform = device.system;
            _module.args = {inherit device inputs;};
          }
          inputs.home-manager.nixosModules.home-manager
          ./${device.name}/configuration.nix
        ];
      }
  )
  devices)
