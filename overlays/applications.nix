{inputs, ...}: final: prev: let
  cratesNix = pkgs: inputs.crates-nix.mkLib {inherit pkgs;};
in {
  glance = prev.glance.overrideAttrs (old: {
    patches = (old.patches or []) ++ [./glance-enclosure-thumbnail.patch];
  });
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
  # dante 1.4.4 fails to compile on darwin clang (config_parse.y type errors).
  # aerc only uses dante to wrap the html filter for SOCKS support, which we
  # don't need — drop the dante input on darwin so aerc builds.
  aerc = prev.aerc.override (
    final.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
      dante = prev.coreutils;
    }
  );
  # direnv 2.37.1 checkPhase hangs on darwin sandbox loading test/.envrc
  direnv =
    if prev.stdenv.hostPlatform.isDarwin
    then prev.direnv.overrideAttrs (_: {doCheck = false;})
    else prev.direnv;
}
