{inputs, ...} @ self: let
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
    command-runner = inputs.command-runner.packages.${prev.system}.command-runner;
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

    openapi-tui = let
      cargoToml = builtins.fromTOML (builtins.readFile "${inputs.openapi-tui}/Cargo.toml");
    in
      final.rustPlatform.buildRustPackage {
        pname = cargoToml.package.name;
        version = cargoToml.package.version;
        src = inputs.openapi-tui;
        cargoLock = {lockFile = "${inputs.openapi-tui}/Cargo.lock";};
        buildInputs = with final;
          pkgs.lib.optionals pkgs.stdenv.isDarwin [
            pkgs.apple-sdk_13
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
            pkgs.openssl
          ];
        PKG_CONFIG_PATH = with final; pkgs.lib.makeSearchPath "lib/pkgconfig" [pkgs.openssl.dev];
        nativeBuildInputs = with final; [pkgs.pkg-config];
      };
    picat = let
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
            owner = "jpochyla";
            repo = "psst";
            rev = "master";
            sha256 = "sha256-W+MFToyvYDQuC/8DqigvENxzJ6QGQOAeAdmdWG6+qZk";
          };
          buildInputs = with final; [
            pkgs.apple-sdk_13
          ];
          cargoLock = {
            lockFile = "${src}/Cargo.lock";
            outputHashes = {
              "cubeb-0.10.3" = "sha256-gV1KHOhq678E/Rj+u8jX9Fw+TepPwuZdV5y/D+Iby+o";
              "druid-0.8.3" = "sha256-hTB9PQf2TAhcLr64VjjQIr18mczwcNogDSRSN5dQULA";
              "druid-enums-0.1.0" = "sha256-KJvAgKxicx/g+4QRZq3iHt6MGVQbfOpyN+EhS6CyDZk";
            };
          };
        };
    # ddcbacklight = inputs.ddcbacklight.packages.${prev.system}.ddcbacklight;
    # ik_llama = prev.llama-cpp.overrideAttrs (oldAttrs: {
    #   src = inputs.ik_llama;
    #   version = "5995";
    # });
    # llama-cpp = prev.llama-cpp.overrideAttrs (oldAttrs: {
    #   src = inputs.llama-cpp;
    #   version = "6178";
    #   cmakeFlags = oldAttrs.cmakeFlags;
    # });
    python312 = prev.python312.override {
      packageOverrides = final: prev: {
        pysaml2 = prev.pysaml2.overridePythonAttrs (orig: {
          doCheck = false;
          # disabledTests =
          #   orig.disabledTests
          #   ++ [
          #     "test_encrypted_response_6"
          #     "test_validate_cert_chains"
          #     "test_validate_with_root_cert"
          #   ];
        });
      };
    };
    zeronsd = let
      src = inputs.zeronsd;
    in
      final.rustPlatform.buildRustPackage {
        inherit src;
        pname = "zeronsd";
        version = "0.6";

        strictDeps = true;
        buildInputs = [final.pkgs.openssl];
        nativeBuildInputs = [final.pkgs.pkg-config];

        doCheck = false;
        RUSTFMT = "${final.pkgs.rustfmt}/bin/rustfmt";

        cargoLock = {lockFile = "${src}/Cargo.lock";};
      };
    # alvr-master = inputs.alvr.packages.${prev.system}.default;
    caddyWithHetzner = final.pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/hetzner@v1.0.0"];
      hash = "sha256-OKzPdgF+tgsu9CxXr3kj9qXcXvyu3eJeajF90PKRatw=";
    };
    nix-auth = inputs.nix-auth.packages.${prev.system}.nix-auth;
    kitty = inputs.nixpkgs-stable.legacyPackages.${prev.system}.kitty;
    yabai = prev.yabai.overrideAttrs (oldAttrs: rec {
      version = "7.1.16";
      src = final.fetchzip {
        url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
        hash = "sha256-rEO+qcat6heF3qrypJ02Ivd2n0cEmiC/cNUN53oia4w=";
      };
    });
  };

  anyrun-overlay = final: prev: {
    anyrun =
      inputs.anyrun.packages.${prev.system}.anyrun.overrideAttrs
      (finalAttrs: prevAttrs: {cargoPatches = [./patches/ctrl-np.patch];});
    hyprwin = inputs.anyrun-hyprwin.packages.${prev.system}.hyprwin;
    nixos-options = inputs.anyrun-nixos-options.packages.${prev.system}.default;
    anyrun-rink = inputs.anyrun-rink.packages.${prev.system}.default;
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
    tmux-float = inputs.tmux-float.packages.${prev.system}.default;
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
  zellij = final: prev: {
    zellijPlugins = {
      zjstatus = inputs.zjstatus.packages.${prev.system}.default;
    };
  };
  libfprint = final: prev: {
    # libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
    #   version = "git";
    #   src = final.fetchFromGitHub {
    #     owner = "ericlinagora";
    #     repo = "libfprint-CS9711";
    #     rev = "03ace5b20146eb01c77fb3ea63e1909984d6d377";
    #     sha256 = "sha256-gr3UvFB6D04he/9zawvQIuwfv0B7fEZb6BGiNAbLids";
    #   };
    #   buildInputs = oldAttrs.buildInputs ++ [final.nss_latest];
    #   nativeBuildInputs =
    #     oldAttrs.nativeBuildInputs
    #     ++ [
    #       final.opencv
    #       final.cmake
    #       final.doctest
    #     ];
    # });
    # # fprintd = inputs.nixpkgs-stable.legacyPackages.${prev.system}.fprintd;
    # fprintd = prev.fprintd.overrideAttrs (oldAttrs: {
    #   src = inputs.nixpkgs-stable.legacyPackages.${prev.system}.fprintd.src;
    # });
  };
  csshacks = final: prev: {
    csshacks = inputs.csshacks;
  };
  jellyfin = final: prev: {
    jellyfin-web = prev.jellyfin-web.overrideAttrs (finalAttrs: previousAttrs: {
      installPhase = ''
        runHook preInstall

        # this is the important line
        sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

        mkdir -p $out/share
        cp -a dist $out/share/jellyfin-web

        runHook postInstall
      '';
    });
  };
  immich = final: prev: {
    immich-latest = prev.immich.overrideAttrs (oldAttrs: {
      version = "v1.142.0";
      src = inputs.immich;
    });
  };
  vr = final: prev: {
    wivrn = prev.wivrn.overrideAttrs (oldAttrs: {
      version = "v25.11.1";
      src = inputs.wivrn;
    });
    # inputs.wivrn.packages.${prev.system}.default;
  };
in
  [
    vr
    anyrun-overlay
    catppuccinThemes
    csshacks
    immich
    inputs.lfca.overlays.default
    inputs.nix-minecraft.overlay
    inputs.nur.overlays.default
    inputs.rust-overlay.overlays.default
    jellyfin
    libfprint
    misc-applications
    nix-index-db
    shell-scipts
    tmuxPlugins
    zellij
  ]
  ++ (import ./neovim/overlays.nix {inherit inputs;})
