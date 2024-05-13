{
  nixpkgs,
  devices,
  inputs,
  overlays,
  lib,
  home-manager,
  nur,
  ...
}:
builtins.listToAttrs (builtins.map (device: {
    name = device.name;
    value = nixpkgs.lib.nixosSystem {
      system = device.system;
      specialArgs = {
        inherit device;
        lanzaboote = inputs.lanzaboote;
      };
      modules =
        [
          nur.nixosModules.nur
          {nixpkgs.overlays = overlays;}
          ./configuration.nix
          home-manager.nixosModules.home-manager
          inputs.lanzaboote.nixosModules.lanzaboote
          {
            nixpkgs.config.allowUnfree = true;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
                inherit device;
              };
              users.${device.user}.imports = [../common/home.nix];
            };
          }
        ]
        ++ lib.optionals device.live [
          (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
        ];
    };
  })
  devices)
