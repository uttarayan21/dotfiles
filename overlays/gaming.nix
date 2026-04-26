{...}: final: prev: {
  bblauncher = final.stdenv.mkDerivation {
    pname = "BBLauncher";
    version = "15.01";
    src = final.fetchFromGitHub {
      owner = "rainmakerv3";
      repo = "BB_Launcher";
      rev = "Release15.01";
      sha256 = "sha256-L3G2DxchadDitZ2d9xE/Q60g9kGyDZjbwcYKth1e/Ww=";
      fetchSubmodules = true;
    };
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

  shadps4 = prev.shadps4.overrideAttrs (oldAttrs: rec {
    version = "0.15.0";
    src = final.fetchFromGitHub {
      owner = "shadps4-emu";
      repo = "shadPS4";
      tag = "v.${version}";
      hash = "sha256-ZYY8PlHEz6jj000Lrllqsk4Da6/CnNdSQHx1+89+yZM=";
      fetchSubmodules = true;
      leaveDotGit = true;
      postFetch = ''
        cd "$out"
        git rev-parse --short=8 HEAD > $out/COMMIT
        date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
        find "$out" -name .git -print0 | xargs -0 rm -rf
      '';
    };
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
      xxHash
      zenity
      zlib-ng
      zydis
    ];
    nativeBuildInputs = with final; [
      cmake
      pkg-config
      makeWrapper
    ];
    installPhase = ''
      runHook preInstall

      install -D -t $out/bin shadps4
      install -Dm644 $src/.github/shadps4.png $out/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png
      install -Dm644 -t $out/share/applications $src/dist/net.shadps4.shadPS4.desktop
      install -Dm644 -t $out/share/metainfo $src/dist/net.shadps4.shadPS4.metainfo.xml

      wrapProgram $out/bin/shadps4 \
        --prefix LD_LIBRARY_PATH : ${
        final.lib.makeLibraryPath [
          final.libpulseaudio
          final.pipewire
        ]
      } \
        --prefix PATH : ${final.lib.makeBinPath [final.zenity]}

      runHook postInstall
    '';
  });

  shadps4-prerelease = final.shadps4.overrideAttrs (oldAttrs: {
    version = "prerelease-2026-04-24";
    src = final.fetchFromGitHub {
      owner = "shadps4-emu";
      repo = "shadPS4";
      rev = "Pre-release-shadPS4-2026-04-25-a762f70";
      hash = "sha256-NLnQ6LB6ar15WsG2wpqWoQm8TpRh4WwHZrVDComn6Nk=";
      fetchSubmodules = true;
    };
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

  shadps4-qt = let
    shadps4 = final.shadps4-prerelease;
    shadps4Wrapped = final.symlinkJoin {
      name = "shadps4-wrapped";
      paths = [shadps4];
      postBuild = let
        versionsJson = final.writeText "versions.json" (builtins.toJSON [
          {
            codename = "built-in";
            name = "built-in";
            path = "@shadps4@";
            type = 0;
          }
        ]);
        qtUiIni = final.writeText "qt_ui.ini" ''
          [version_manager]
          versionSelected=@shadps4@
        '';
      in ''
        mkdir -p $out/share
        substitute ${versionsJson} $out/share/versions.json \
          --replace-fail @shadps4@ $out/bin/shadps4
        substitute ${qtUiIni} $out/share/qt_ui.ini \
          --replace-fail @shadps4@ $out/bin/shadps4
      '';
    };
  in
    prev.stdenv.mkDerivation {
      pname = "shadps4-qt";
      version = "224";

      src = final.fetchFromGitHub {
        owner = "shadps4-emu";
        repo = "shadps4-qtlauncher";
        tag = "v224";
        hash = "sha256-KBjAP0t2A6Q0eD7A0/9HzIQrUJ97YUkx2nx4SB+poHU=";
        fetchSubmodules = true;
      };

      postPatch = ''
        substituteInPlace src/common/scm_rev.cpp.in \
          --replace-fail @APP_VERSION@ ${shadps4.version} \
          --replace-fail @GIT_REV@ v224 \
          --replace-fail @GIT_BRANCH@ v224 \
          --replace-fail @GIT_DESC@ nixpkgs \
          --replace-fail @BUILD_DATE@ 1970-01-01T00:00:00Z

        substituteInPlace src/common/versions.cpp \
          --replace-fail 'Common::FS::GetUserPath(Common::FS::PathType::LauncherDir) / "versions.json"' \
          '"${shadps4Wrapped}/share/versions.json"'

        substituteInPlace src/qt_gui/gui_settings.cpp \
          --replace-fail 'ComputeSettingsDir() + "qt_ui.ini"' \
          'QString::fromStdString("${shadps4Wrapped}/share/qt_ui.ini")'
      '';

      inherit (shadps4) cmakeBuildType dontStrip runtimeDependencies;

      nativeBuildInputs =
        (shadps4.nativeBuildInputs or [])
        ++ [
          final.qt6.wrapQtAppsHook
        ];

      buildInputs =
        (shadps4.buildInputs or [])
        ++ [
          final.qt6.qtbase
          final.qt6.qttools
          final.qt6.qtmultimedia
        ];

      cmakeFlags = [
        (final.lib.cmakeBool "ENABLE_UPDATER" false)
        (final.lib.cmakeBool "HIDE_VERSION_MANAGER" true)
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        ln -s ${shadps4Wrapped}/bin/shadps4 $out/bin

        install -Dm644 $src/.github/shadps4.png $out/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png
        install -Dm644 -t $out/share/applications $src/dist/net.shadps4.shadps4-qtlauncher.desktop
        install -Dm644 -t $out/share/metainfo $src/dist/net.shadps4.shadps4-qtlauncher.metainfo.xml

        install -Dm755 shadPS4QtLauncher $out/bin/shadps4-qt

        runHook postInstall
      '';

      fixupPhase = ''
        runHook preFixup

        substituteInPlace $out/share/applications/net.shadps4.shadps4-qtlauncher.desktop \
          --replace-fail 'Exec=shadPS4QtLauncher' 'Exec=shadps4-qt'

        runHook postFixup
      '';

      meta = {
        inherit (shadps4.meta) platforms license maintainers;
        description = shadps4.meta.description + " (Qt UI)";
        homepage = "https://github.com/shadps4-emu/shadps4-qtlauncher";
        mainProgram = "shadps4-qt";
      };
    };
}
