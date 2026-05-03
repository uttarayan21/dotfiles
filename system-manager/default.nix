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
          ./${device.name}/configuration.nix
        ];
      }
  )
  devices)
