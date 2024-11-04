{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

  outputs = {
    nixpkgs,
    disko,
    nixos-facter-modules,
    ...
  }: {
    # Use this for all other targets
    # nix run github:nix-community/nixos-anywhere -- --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix root@sh.darksailor.dev
    nixosConfigurations.generic = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };

    # Slightly experimental: Like generic, but with nixos-facter (https://github.com/numtide/nixos-facter)
    # nix run github:nix-community/nixos-anywhere -- --flake .#generic-nixos-facter --generate-hardware-config nixos-facter facter.json root@sh.darksailor.dev
    nixosConfigurations.generic-nixos-facter = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./configuration.nix
        nixos-facter-modules.nixosModules.facter
        {
          config.facter.reportPath =
            if builtins.pathExists ./facter.json
            then ./facter.json
            else throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
        }
      ];
    };
  };
}
