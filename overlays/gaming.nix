{inputs, ...}: final: prev: let
  # Format flake input lastModifiedDate ("YYYYMMDDHHMMSS") as ISO-8601 UTC.
  isoDate = d: "${builtins.substring 0 4 d}-${builtins.substring 4 2 d}-${builtins.substring 6 2 d}T${builtins.substring 8 2 d}:${builtins.substring 10 2 d}:${builtins.substring 12 2 d}Z";

  mkShadps4Qt = {
    base,
    pname,
    descSuffix,
  }:
    base.overrideAttrs (oldAttrs: {
      inherit pname;

      nativeBuildInputs =
        (oldAttrs.nativeBuildInputs or [])
        ++ [
          final.qt6.wrapQtAppsHook
        ];

      buildInputs =
        (oldAttrs.buildInputs or [])
        ++ [
          final.qt6.qtbase
          final.qt6.qttools
          final.qt6.qtmultimedia
          final.openssl
        ];

      cmakeFlags =
        (oldAttrs.cmakeFlags or [])
        ++ [
          (final.lib.cmakeBool "ENABLE_QT_GUI" true)
        ];

      installPhase = ''
        runHook preInstall

        install -D -t $out/bin shadps4
        ln -s shadps4 $out/bin/${pname}

        install -Dm644 $src/.github/shadps4.png $out/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png
        install -Dm644 -t $out/share/applications $src/dist/net.shadps4.shadPS4.desktop
        install -Dm644 -t $out/share/metainfo $src/dist/net.shadps4.shadPS4.metainfo.xml

        runHook postInstall
      '';

      meta =
        (oldAttrs.meta or {})
        // {
          description = (oldAttrs.meta.description or "shadPS4") + " " + descSuffix;
          mainProgram = pname;
        };
    });
in {
  bblauncher = final.stdenv.mkDerivation {
    pname = "BBLauncher";
    version = "15.01";
    src = inputs.bblauncher-src;
    nativeBuildInputs = [
      final.cmake
      final.pkg-config
      final.qt6.wrapQtAppsHook
    ];
    buildInputs = [
      final.alsa-lib
      final.ffmpeg
      final.fmt
      final.glslang
      final.jack2
      final.libedit
      final.libevdev
      final.libpng
      final.libpulseaudio
      final.libxkbcommon
      final.openal
      final.openssl
      final.qt6.qtbase
      final.qt6.qtmultimedia
      final.qt6.qttools
      final.qt6.qtwayland
      final.qt6.qtwebview
      final.SDL2
      final.sdl3
      final.sndio
      final.stb
      final.udev
      final.vulkan-headers
      final.vulkan-tools
      final.vulkan-utility-libraries
      final.wayland
      final.wayland-protocols
      final.libxcb
      final.xcbutil
      final.xcbutilkeysyms
      final.xcbutilwm
      final.zlib
    ];
  };

  shadps4 = final.llvmPackages_19.stdenv.mkDerivation (finalAttrs: {
    pname = "shadps4";
    version = "0.15.0";
    src = inputs.shadps4-src;

    postPatch = ''
      echo "${builtins.substring 0 8 inputs.shadps4-src.rev}" > COMMIT
      echo "${isoDate inputs.shadps4-src.lastModifiedDate}" > SOURCE_DATE_EPOCH
      substituteInPlace src/common/scm_rev.cpp.in \
        --replace-fail @APP_VERSION@ ${finalAttrs.version} \
        --replace-fail @GIT_REV@ $(cat COMMIT) \
        --replace-fail @GIT_BRANCH@ ${finalAttrs.version} \
        --replace-fail @GIT_DESC@ nixpkgs \
        --replace-fail @BUILD_DATE@ $(cat SOURCE_DATE_EPOCH)
    '';

    nativeBuildInputs = with final; [
      cmake
      pkg-config
      makeWrapper
    ];

    buildInputs = with final; [
      alsa-lib
      boost
      cryptopp
      glslang
      ffmpeg
      fmt
      half
      jack2
      libdecor
      libpulseaudio
      libunwind
      libusb1
      libx11
      libxcb
      libxcursor
      libxext
      libxi
      libxrandr
      libxscrnsaver
      libxtst
      magic-enum
      libgbm
      pipewire
      pugixml
      rapidjson
      renderdoc
      robin-map
      sndio
      stb
      toml11
      util-linux
      vulkan-headers
      vulkan-loader
      vulkan-memory-allocator
      xbyak
      xxhash
      zenity
      zlib-ng
      zydis
    ];

    env.NIX_CFLAGS_COMPILE = "-march=native -O3 -fno-plt";

    cmakeBuildType = "Release";
    dontStrip = false;

    cmakeFlags = [
      # Disabled: upstream gates this behind a kernel-bug regression (issue #1704)
      # (final.lib.cmakeBool "ENABLE_USERFAULTFD" true)
      (final.lib.cmakeBool "ENABLE_DISCORD_RPC" false)
      (final.lib.cmakeBool "ENABLE_UPDATER" false)
    ];

    installPhase = ''
      runHook preInstall

      install -D -t $out/bin shadps4
      install -Dm644 $src/.github/shadps4.png $out/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png
      install -Dm644 -t $out/share/applications $src/dist/net.shadps4.shadPS4.desktop
      install -Dm644 -t $out/share/metainfo $src/dist/net.shadps4.shadPS4.metainfo.xml

      wrapProgram $out/bin/shadps4 \
        --prefix LD_LIBRARY_PATH : ${final.lib.makeLibraryPath [final.libpulseaudio final.pipewire]} \
        --prefix PATH : ${final.lib.makeBinPath [final.zenity]}

      runHook postInstall
    '';

    runtimeDependencies = with final; [vulkan-loader libxi];

    meta = {
      description = "Early in development PS4 emulator (perf-tuned)";
      homepage = "https://github.com/shadps4-emu/shadPS4";
      license = final.lib.licenses.gpl2Plus;
      mainProgram = "shadps4";
      platforms = final.lib.intersectLists final.lib.platforms.linux final.lib.platforms.x86_64;
    };
  });

  shadps4-prerelease = final.shadps4.overrideAttrs (oldAttrs: {
    version = "prerelease-2026-04-24";
    src = inputs.shadps4-prerelease-src;
    patches =
      (oldAttrs.patches or [])
      ++ [
        ../patches/shadps4-image-spec-num-bindings.patch
      ];
    postPatch = ''
      echo "615949ea" > COMMIT
      echo "2026-04-24T00:00:00Z" > SOURCE_DATE_EPOCH
      substituteInPlace src/common/scm_rev.cpp.in \
        --replace-fail @APP_VERSION@ prerelease-2026-04-24 \
        --replace-fail @GIT_REV@ 615949ea \
        --replace-fail @GIT_BRANCH@ main \
        --replace-fail @GIT_DESC@ nixpkgs \
        --replace-fail @BUILD_DATE@ 2026-04-24T00:00:00Z
    '';
  });

  shadps4-diegolix29 = final.shadps4.overrideAttrs (oldAttrs: {
    version = "diegolix29-2026-04-25";
    src = inputs.shadps4-diegolix29-src;
    patches =
      (oldAttrs.patches or [])
      ++ [
        ../patches/shadps4-image-spec-num-bindings.patch
      ];
    postPatch = ''
      echo "6e87e749" > COMMIT
      echo "2026-04-25T08:08:02Z" > SOURCE_DATE_EPOCH
      substituteInPlace src/common/scm_rev.cpp.in \
        --replace-fail @APP_VERSION@ diegolix29-2026-04-25 \
        --replace-fail @GIT_REV@ 6e87e749 \
        --replace-fail @GIT_BRANCH@ main \
        --replace-fail @GIT_DESC@ nixpkgs \
        --replace-fail @BUILD_DATE@ 2026-04-25T08:08:02Z
    '';
  });

  # Vanilla Qt launcher lives in its own repo (shadps4-qtlauncher) since the Qt
  # GUI was split out of the main shadPS4 codebase. Build from that source tree
  # rather than the main emulator repo.
  shadps4-qt =
    (mkShadps4Qt {
      base = final.shadps4;
      pname = "shadps4-qt";
      descSuffix = "(Qt UI)";
    }).overrideAttrs (_: {
      version = "qtlauncher-2026-04-30";
      src = inputs.shadps4-qtlauncher-src;
      postPatch = ''
        echo "${builtins.substring 0 8 inputs.shadps4-qtlauncher-src.rev}" > COMMIT
        echo "${isoDate inputs.shadps4-qtlauncher-src.lastModifiedDate}" > SOURCE_DATE_EPOCH
      '';
      installPhase = ''
        runHook preInstall

        install -D -t $out/bin shadPS4QtLauncher
        ln -s shadPS4QtLauncher $out/bin/shadps4-qt

        install -Dm644 $src/.github/shadps4.png $out/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png
        install -Dm644 -t $out/share/applications $src/dist/net.shadps4.shadps4-qtlauncher.desktop
        install -Dm644 -t $out/share/metainfo $src/dist/net.shadps4.shadps4-qtlauncher.metainfo.xml

        runHook postInstall
      '';
    });

  shadps4-qt-diegolix = mkShadps4Qt {
    base = final.shadps4-diegolix29;
    pname = "shadps4-qt-diegolix";
    descSuffix = "(Qt UI, diegolix29 fork)";
  };
}
