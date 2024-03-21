{inputs, ...}: let
  shell-scipts = final: prev: {
    handlr-xdg = final.pkgs.writeShellApplication {
      name = "xdg-open";
      runtimeInputs = [final.pkgs.handlr-regex];
      text = ''
        handlr open "$@"
      '';
    };
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
      patches = [patches/goread.patch];
      checkPhase = null;
    };
    music-player-git = inputs.music-player.packages.${prev.system}.default;
    davis = let
      davis-src = final.pkgs.fetchFromGitHub {
        owner = "SimonPersson";
        repo = "davis";
        rev = "main";
        sha256 = "sha256-p4l1nF6M28OyIaPorgsyR7NJtmVwpmuws67KvVnJa8s";
      };
      cargoToml =
        builtins.fromTOML (builtins.readFile "${davis-src}/Cargo.toml");
    in
      final.rustPlatform.buildRustPackage {
        pname = cargoToml.package.name;
        version = cargoToml.package.version;
        src = davis-src;
        cargoLock = {lockFile = "${davis-src}/Cargo.lock";};
        buildPhase = ''
          runHook cargoBuildHook
          runHook cargoInstallPostBuildHook
        '';
        runtimeInputs = [final.pkgs.picat];
        buildInputs = [final.pkgs.picat];
        installPhase = ''
          mkdir -p $out/bin
          cp $bins $out/bin
          cp $src/subcommands/cur/davis-cur-vertical $out/bin
          cp $src/subcommands/cur/davis-cur-horizontal $out/bin
          cp $src/subcommands/cover/davis-cover $out/bin
        '';
      };

    picat = let
      # https://github.com/SimonPersson/picat
      picat-src = final.pkgs.fetchFromGitHub {
        owner = "SimonPersson";
        repo = "picat";
        rev = "main";
        sha256 = "sha256-HheBinHW4RLjRtiE8Xe5BoEuSCdtZTA9XkRJgtDkXaM";
      };
      cargoToml =
        builtins.fromTOML (builtins.readFile "${picat-src}/Cargo.toml");
    in
      final.rustPlatform.buildRustPackage {
        pname = cargoToml.package.name;
        version = cargoToml.package.version;
        src = picat-src;
        cargoLock = {lockFile = "${picat-src}/Cargo.lock";};
      };

    psst =
      if final.pkgs.stdenv.isLinux
      then
        (prev.psst.overrideAttrs (finalAttrs: prevAttrs: {
          postInstall =
            (prevAttrs.postInstall or "")
            + ''
              patch $out/share/applications/Psst.desktop < ${./patches/psst.patch}
            '';
        }))
      else
        final.rustPlatform.buildRustPackage rec {
          pname = "psst";
          version = "1";
          src = final.pkgs.fetchFromGitHub {
            # https://github.com/jpochyla/psst
            owner = "jpochyla";
            repo = "psst";
            rev = "master";
            sha256 = "sha256-W+MFToyvYDQuC/8DqigvENxzJ6QGQOAeAdmdWG6+qZk";
          };
          buildInputs = with final; [
            pkgs.darwin.apple_sdk.frameworks.CoreAudio
            pkgs.darwin.apple_sdk.frameworks.AudioUnit
          ];
          # nativeBuildInputs = buildInputs;
          cargoLock = {
            lockFile = "${src}/Cargo.lock";
            outputHashes = {
              "cubeb-0.10.3" = "sha256-gV1KHOhq678E/Rj+u8jX9Fw+TepPwuZdV5y/D+Iby+o";
              "druid-0.8.3" = "sha256-hTB9PQf2TAhcLr64VjjQIr18mczwcNogDSRSN5dQULA";
              "druid-enums-0.1.0" = "sha256-KJvAgKxicx/g+4QRZq3iHt6MGVQbfOpyN+EhS6CyDZk";
            };
          };
        };
  };

  anyrun-overlay = final: prev: {
    anyrun =
      inputs.anyrun.packages.${prev.system}.anyrun.overrideAttrs
      (finalAttrs: prevAttrs: {cargoPatches = [./patches/anyrun.patch];});
    hyprwin = inputs.anyrun-hyprwin.packages.${prev.system}.hyprwin;
    nixos-options = inputs.anyrun-nixos-options.packages.${prev.system}.default;
    anyrun-rink = inputs.anyrun-rink.packages.${prev.system}.default;
  };
  vimPlugins = final: prev: {
    vimPlugins =
      prev.vimPlugins
      // {
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
    tmuxPlugins =
      prev.tmuxPlugins
      // {
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
    catppuccinThemes = import ./themes/catppuccin.nix {pkgs = final.pkgs;};
  };

  nix-index-db = final: prev: {
    nix-index-database = final.runCommandLocal "nix-index-database" {} ''
      mkdir -p $out
      ln -s ${
        inputs.nix-index-database.legacyPackages.${prev.system}.database
      } $out/files
    '';
  };

  # nixneovim = nixneovim.applyPatches {
  #   name = "nixneovim-patched";
  #   src = inputs.nixneovim;
  #   patches = [ ./patches/nixneovim.patch ];
  # };

  tree-sitter-grammars = final: prev: {
    tree-sitter-grammars =
      prev.tree-sitter-grammars
      // {
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
  };
in [
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
  # inputs.rustaceanvim.overlays.default
]
