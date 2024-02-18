{ nixpkgs, devices, inputs, overlays, home-manager, ... }:
builtins.listToAttrs (builtins.map (device: {
  name = device.name;
  value = nixpkgs.lib.nixosSystem {
    system = device.system;
    specialArgs = { inherit device; };
    modules = [
      { nixpkgs.overlays = overlays; }
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
        nixpkgs.config.allowUnfree = true;
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs;
            inherit device;
          };
          users.${device.user}.imports = [ ../common/home.nix ];
        };
      }
    ];
  };
}) devices)