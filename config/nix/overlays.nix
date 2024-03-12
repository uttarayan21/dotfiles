{ inputs, ... }:
let
  anyrun-overlay = final: prev: {
    anyrun = inputs.anyrun.packages.${prev.system}.anyrun;
    hyprwin = inputs.anyrun-hyprwin.packages.${prev.system}.hyprwin;
    nixos-options =
      inputs.anyrun-nixos-options.packages.${prev.system}.default;
    anyrun-rink = inputs.anyrun-rink.packages.${prev.system}.default;
  };
  vimPlugins = final: prev: {
    vimPlugins = prev.vimPlugins // {
      # nvim-treesitter
      comfortable-motion = final.pkgs.vimUtils.buildVimPlugin {
        name = "comfortable-motion";
        src = final.pkgs.fetchFromGitHub {
          owner = "yuttie";
          repo = "comfortable-motion.vim";
          rev = "master";
          sha256 = "sha256-S1LJXmShhpCJIg/FEPx3jFbmPpS/1U4MAQN2RY/nkI0";
        };
      };
      sqls-nvim = final.pkgs.vimUtils.buildVimPlugin {
        name = "sqls-nvim";
        src = final.pkgs.fetchFromGitHub {
          owner = "nanotee";
          repo = "sqls.nvim";
          rev = "master";
          sha256 = "sha256-jKFut6NZAf/eIeIkY7/2EsjsIhvZQKCKAJzeQ6XSr0s";
        };
      };
      outline-nvim = final.pkgs.vimUtils.buildVimPlugin {
        name = "outline-nvim";
        src = final.pkgs.fetchFromGitHub {
          owner = "hedyhli";
          repo = "outline.nvim";
          rev = "master";
          sha256 = "sha256-HaxfnvgFy7fpa2CS7/dQhf6dK9+Js7wP5qGdIeXLGPY";
        };
      };
      rest-nvim = final.pkgs.vimUtils.buildVimPlugin {
        name = "rest-nvim";
        src = final.pkgs.fetchFromGitHub {
          owner = "rest-nvim";
          repo = "rest.nvim";
          rev = "main";
          sha256 = "sha256-EclCwr0Oi6+5zF47niO0nt8wjNmb6cAADxd7S71DAiI";
        };
      };
    };
  };
  tmuxPlugins = final: prev: {
    tmuxPlugins = prev.tmuxPlugins // {

      tmux-super-fingers = final.pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tmux-super-fingers";
        version = "v1-2024-02-14";
        src = final.pkgs.fetchFromGitHub {
          owner = "artemave";
          repo = "tmux_super_fingers";
          rev = "518044ef78efa1cf3c64f2e693fef569ae570ddd";
          sha256 = "sha256-iKfx9Ytk2vSuINvQTB6Kww8Vv7i51cFEnEBHLje+IJw=";
        };
      };
    };
  };
  catppuccinThemes = final: prev: {
    catppuccinThemes =
      import ./themes/catppuccin.nix { pkgs = final.pkgs; };
  };

  nix-index-db = (final: prev: {
    nix-index-database = final.runCommandLocal "nix-index-database" { } ''
      mkdir -p $out
      ln -s ${inputs.nix-index-database.legacyPackages.${prev.system}.database} $out/files
    '';
  });
in
[
  catppuccinThemes
  vimPlugins
  tmuxPlugins
  inputs.neovim-nightly-overlay.overlay
  anyrun-overlay
  inputs.nixneovim.overlays.default
  # inputs.nixneovimplugins.overlays.default
  inputs.nur.overlay
  nix-index-db
]
