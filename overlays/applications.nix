{inputs, ...}: final: prev: let
  cratesNix = pkgs: inputs.crates-nix.mkLib {inherit pkgs;};
in {
  iamb = inputs.iamb.packages.${prev.stdenv.hostPlatform.system}.default;
  # hyprland = inputs.hyprland.packages.${prev.stdenv.hostPlatform.system}.hyprland;
  # xdg-desktop-portal-hyprland = prev.enableDebugging inputs.hyprland.packages.${prev.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  # xdph = inputs.nixpkgs-master.legacyPackages.${prev.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  opencode = inputs.nixpkgs-master.legacyPackages.${prev.stdenv.hostPlatform.system}.opencode;
  ironclaw = (cratesNix prev).buildCrate "ironclaw" {
    nativeBuildInputs = [prev.pkg-config];
    buildInputs = [prev.openssl];
    doCheck = false;
  };
  less = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.less;
  notmuch = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.notmuch;
  # nushell = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.nushell;
}
