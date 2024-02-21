{
  devices,
  inputs,
  overlays,
  home-manager,
  ...
}:
builtins.listToAttrs (builtins.map (device: {
    name = device.user;
    value = let
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
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
          }
          ../common/home.nix
        ];
      };
  })
  devices)
