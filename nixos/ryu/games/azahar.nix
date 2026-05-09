{pkgs, ...}: let
  azahar-xcb = pkgs.symlinkJoin {
    name = "azahar";
    paths = [pkgs.azahar];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/azahar \
        --set QT_QPA_PLATFORM xcb
    '';
  };
in {
  environment.systemPackages = [azahar-xcb];
}
