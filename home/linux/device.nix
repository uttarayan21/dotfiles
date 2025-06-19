{
  devices,
  inputs,
  overlays,
  home-manager,
  ...
}: (builtins.mapAttrs (
    name: device: let
      pkgs = import inputs.nixpkgs {
        inherit overlays;
        system = device.system;
      };
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit device;
        };
        modules = [{nixpkgs.config.allowUnfree = true;} ../common/home.nix];
      }
  )
  devices)
