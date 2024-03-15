{ inputs, ... }:
let
  shell-scipts = final: prev: {
    handlr-xdg = (final.pkgs.writeShellApplication {
      name = "xdg-open";
      runtimeInputs = [ final.pkgs.handlr-regex ];
      text = ''
        handlr open "$@"
      '';
    });
  };

  misc-applications = final: prev: {
    goread = final.pkgs.buildGoModule {
      pname = "goread";
      version = "v1.6.4";
      vendorHash = "sha256-/kxEnw8l9S7WNMcPh1x7xqiQ3L61DSn6DCIvJlyrip0";
      src = final.pkgs.fetchFromGitHub {
        owner = "TypicalAM";
        repo = "goread";
        rev = "v1.6.4";
        sha256 = "sha256-m6reRaJNeFhJBUatfPNm66LwTXPdD/gioT8HTv52QOw";
      };
      checkPhase = null;
    };
  };

  anyrun-overlay = final: prev: {
    anyrun = inputs.anyrun.packages.${prev.system}.anyrun;
    hyprwin = inputs.anyrun-hyprwin.packages.${prev.system}.hyprwin;
    nixos-options =
      inputs.anyrun-nixos-options.packages.${prev.system}.default;
    anyrun-rink = inputs.anyrun-rink.packages.${prev.system}.default;
  };
  vimPlugins = final: prev: {
    vimPlugins = prev.vimPlugins // {
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
          sha256 = "sha256-3EC0j/hEbdQ8nJU0I+LGmE/zNnglO/FrP/6POer0338=";
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

  tree-sitter-grammars = (final: prev: {
    tree-sitter-grammars = prev.tree-sitter-grammars // {
      tree-sitter-just = final.pkgs.tree-sitter.buildGrammar {
        language = "just";
        version = "1";
        src = final.pkgs.fetchFromGitHub {
          owner = "IndianBoy42";
          repo = "tree-sitter-just";
          rev = "613b3fd39183bec94bc741addc5beb6e6f17969f";
          sha256 = "sha256-OBlXwWriE6cdGn0dhpfSMnJ6Rx1Z7KcXehaamdi/TxQ";
        };
      };
    };
  });
in
[
  catppuccinThemes
  vimPlugins
  tree-sitter-grammars
  tmuxPlugins
  anyrun-overlay
  nix-index-db
  shell-scipts
  misc-applications
  inputs.neovim-nightly-overlay.overlay
  inputs.nixneovim.overlays.default
  inputs.nur.overlay
  inputs.rustaceanvim.overlays.default
]
