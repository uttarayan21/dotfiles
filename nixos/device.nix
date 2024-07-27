{
  nixpkgs,
  devices,
  inputs,
  overlays,
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
          inputs.musnix.nixosModules.musnix
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
        ++ nixpkgs.lib.optionals device.live [
          (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
          ({pkgs, ...}: {
            systemd.services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
            users.users.root.openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdV/cFR8ENy4vCHnK/dL+Ud7jOJV7+iLeAe8y5nj3xF email@uttarayan.me"
            ];
          })
        ];
    };
  })
  devices)
