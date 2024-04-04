{
  description = "Get all overlays as subflakes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    csshacks.url = "github:MrOtherGuy/firefox-csshacks";
    csshacks.flake = false;
  };
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    overlay = final: prev: {
      csshacks = inputs.csshacks;
    };
  in {overlays.default = overlay;};
}
