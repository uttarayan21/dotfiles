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
      # TODO: Move to subflake
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
      # TODO: Move to subflake
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
      # TODO: Move to subflake
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
    pylyzer = prev.pylyzer.override {
      rustPlatform = final.makeRustPlatform {
        rustc = final.pkgs.rust-bin.stable."1.75.0".default;
        cargo = final.pkgs.cargo;
      };
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
          # TODO: Move to subflake
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
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "yuttie";
            repo = "comfortable-motion.vim";
            rev = "master";
            sha256 = "sha256-S1LJXmShhpCJIg/FEPx3jFbmPpS/1U4MAQN2RY/nkI0";
          };
        };
        nvim-dap-rr = final.pkgs.vimUtils.buildVimPlugin {
          name = "nvim-dap-rr";
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "jonboh";
            repo = "nvim-dap-rr";
            rev = "master";
            sha256 = "sha256-JNztLTSyHmEmh3xT4WR0cpP25vjZ4A6aQbnU49U6+Ss";
          };
        };
        sqls-nvim = final.pkgs.vimUtils.buildVimPlugin {
          name = "sqls-nvim";
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "nanotee";
            repo = "sqls.nvim";
            rev = "master";
            sha256 = "sha256-jKFut6NZAf/eIeIkY7/2EsjsIhvZQKCKAJzeQ6XSr0s";
          };
        };
        outline-nvim = final.pkgs.vimUtils.buildVimPlugin {
          name = "outline-nvim";
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "hedyhli";
            repo = "outline.nvim";
            rev = "master";
            sha256 = "sha256-HaxfnvgFy7fpa2CS7/dQhf6dK9+Js7wP5qGdIeXLGPY";
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
          # TODO: Move to subflake
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
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "IndianBoy42";
            repo = "tree-sitter-just";
            rev = "613b3fd39183bec94bc741addc5beb6e6f17969f";
            sha256 = "sha256-OBlXwWriE6cdGn0dhpfSMnJ6Rx1Z7KcXehaamdi/TxQ";
          };
        };
        tree-sitter-nu = final.pkgs.tree-sitter.buildGrammar {
          language = "nu";
          version = "0.0.1";
          # TODO: Move to subflake
          src = final.pkgs.fetchFromGitHub {
            owner = "nushell";
            repo = "tree-sitter-nu";
            rev = "c5b7816043992b1cdc1462a889bc74dc08576fa6";
            sha256 = "sha256-P+ixE359fAW7R5UJLwvMsmju7UFmJw5SN+kbMEw7Kz0=";
          };
        };
      };
  };
  rest-nvim-overlay = final: prev: let
    # TODO: Move to subflake
    rest-nvim-src = final.pkgs.fetchFromGitHub {
      owner = "rest-nvim";
      repo = "rest.nvim";
      # rev = "64175b161b61b6807b4c6f3f18dd884325cf04e0";
      # Before v2 release
      rev = "v1.0.0";
      # sha256 = "sha256-3EC0j/hEbdQ8nJU0I+LGmE/zNnglO/FrP/6POer0338";
      # sha256 = "sha256-3EC0j/hEbdQ8nJU0I+LGmE/zNnglO/FrP/6POer0339";
      sha256 = "sha256-jSY5WXx5tQAD0ZefPbg2luHywGAMcB9wdUTy6Av3xnY";
    };
  in {
    vimPlugins =
      prev.vimPlugins
      // {
        rest-nvim = final.vimUtils.buildVimPlugin {
          pname = "rest.nvim";
          version = "1.0.0";
          src = rest-nvim-src;
          # version = "scm-1";
          # rockspecVersion = "0.2-1";
          # buildInputs = with final.pkgs.lua51Packages; [lua lua-curl mimetypes nvim-nio xml2lua];
        };
      };
    # lua51Packages =
    #   prev.lua51Packages
    #   // {
    #     rest-nvim = final.lua.buildLuarocksPackage {
    #       pname = "rest.nvim";
    #       version = "scm-1";
    #       src = rest-nvim-src;
    #       buildInputs = with final.lua51Packages; [lua lua-curl mimetypes nvim-nio xml2lua];
    #     };
    #   };
  };
  catppuccin = final: prev: {
    pythonPackagesExtensions =
      prev.pythonPackagesExtensions
      ++ [
        (
          python-final: python-prev: {
            catppuccin = python-prev.catppuccin.overridePythonAttrs (oldAttrs: rec {
              version = "1.3.2";
              # TODO: Move to subflake
              src = prev.fetchFromGitHub {
                owner = "catppuccin";
                repo = "python";
                rev = "refs/tags/v${version}";
                hash = "sha256-spPZdQ+x3isyeBXZ/J2QE6zNhyHRfyRQGiHreuXzzik=";
              };
              # can be removed next version
              disabledTestPaths = [
                "tests/test_flavour.py" # would download a json to check correctness of flavours
              ];
            });
          }
        )
      ];
  };
  zellij = final: prev: {
    zellijPlugins = {
      zjstatus = inputs.zjstatus.packages.${prev.system}.default;
    };
  };
in [
  inputs.subflakes.overlays.default
  zellij
  catppuccinThemes
  vimPlugins
  rest-nvim-overlay
  tree-sitter-grammars
  tmuxPlugins
  anyrun-overlay
  nix-index-db
  shell-scipts
  misc-applications
  inputs.neovim-nightly-overlay.overlay
  inputs.nur.overlay
  catppuccin
  inputs.rust-overlay.overlays.default
]
