{
  description = "Get all overlays as subflakes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nvim-devdocs.url = "github:luckasRanarison/nvim-devdocs";
    nvim-devdocs.flake = false;
  };
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    overlay = final: prev: {
      vimPlugins =
        prev.vimPlugins
        // {
          nvim-devdocs = final.pkgs.vimUtils.buildVimPlugin {
            pname = "nvim-devdocs";
            version = "0.4.1";
            src = inputs.nvim-devdocs;
          };
        };
    };
  in {overlays.default = overlay;};
}
