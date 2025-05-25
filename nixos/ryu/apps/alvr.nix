{
  pkgs,
  lib,
  ...
}: {
  # package = pkgs.alvr.overrideAttrs (oldAttrs: {
  #   src = pkgs.fetchFromGitHub {
  #     owner = "alvr-org";
  #     repo = "ALVR-nightly";
  #     rev = "2fded66a929b6eaa7dd9c1cd986f67a6660c01bb";
  #     fetchSubmodules = true;
  #     hash = "sha256-x7RSTxHXwdjVVcbKkEA9tgER0gu8rjq0R62SAJWxoo0=";
  #   };
  # });
  programs.alvr = {
    enable = true;
    openFirewall = true;
    package = pkgs.alvr-master;
    # package = pkgs.alvr.overrideAttrs (oldAttrs: {
    #   nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.cudatoolkit];
    #   buildInputs = oldAttrs.buildInputs ++ [pkgs.cudatoolkit];
    #   patches = [
    #     (pkgs.replaceVars ../../../patches/fix-finding-libs.patch {
    #       ffmpeg = lib.getDev pkgs.ffmpeg;
    #       x264 = lib.getDev pkgs.x264;
    #     })
    #   ];
    # });
  };
}
