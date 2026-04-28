{inputs, ...}: final: prev: {
  catppuccinThemes = import ../themes/catppuccin.nix {
    inherit inputs;
    pkgs = final.pkgs;
  };
  nix-index-database = final.runCommandLocal "nix-index-database" {} ''
    mkdir -p $out
    ln -s ${inputs.nix-index-database.legacyPackages.${prev.stdenv.hostPlatform.system}.database} $out/files
  '';
}
