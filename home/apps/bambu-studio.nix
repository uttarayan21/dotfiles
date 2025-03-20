{pkgs, ...}: {
  home.packages = with pkgs; [
    (bambu-studio.overrideAttrs (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.cudatoolkit];
      buildInputs = oldAttrs.buildInputs ++ [pkgs.cudatoolkit];
    }))
  ];
}
