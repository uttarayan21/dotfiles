{
  pkgs,
  lib,
  ...
}: let
  shadps4_qtlauncher = pkgs.fetchFromGitHub {
    owner = "shadps4-emu";
    repo = "shadps4-qtlauncher";
    rev = "62704a8a0450792608d9644e38b2627c543bc971";
    sha256 = "sha256-NKt6AGSkhR7wyo7PP5Lgh9UhVbt3lWu/qygMvyD56wk=";
    fetchSubmodules = true;
  };
  # diegolixShadps4 = pkgs.fetchFromGitHub {
  #   owner = "diegolix";
  #   repo = "shadps4-qtlauncher";
  #   rev = "a1b2c3d4e5f67890123456789abcdef01234567";
  #   sha256 = "sha256-PLACEHOLDERFORHASHVALUE1234567890ABCDEFGH=";
  #   fetchSubmodules = true;
  # };
  bblauncher = pkgs.fetchFromGitHub {
    owner = "rainmakerv3";
    repo = "BB_Launcher";
    rev = "d0f7698de7d79a1a6078273843ad9e4c76442168";
    sha256 = "sha256-ECwN0g4DVTC6LepFCD28I7mpvETZcOwCeIZ6dIcEh6Q=";
    fetchSubmodules = true;
  };
in {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    (pkgs.shadps4.overrideAttrs
      (oldAttrs: {
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.cudatoolkit];
        buildInputs = oldAttrs.buildInputs ++ [pkgs.cudatoolkit];
      }))
    (pkgs.stdenv.mkDerivation {
      pname = "shadps4-qt";
      version = "1.0.0";
      src = shadps4_qtlauncher;
      nativeBuildInputs = [
        pkgs.cmake
        pkgs.pkg-config
        pkgs.qt6.wrapQtAppsHook
      ];
      buildInputs = [
        pkgs.alsa-lib
        pkgs.ffmpeg
        pkgs.fmt
        pkgs.glslang
        pkgs.jack2
        pkgs.libedit
        pkgs.libevdev
        pkgs.libpng
        pkgs.libpulseaudio
        pkgs.libxkbcommon
        pkgs.openal
        pkgs.openssl
        pkgs.qt6.qtbase
        pkgs.qt6.qtmultimedia
        pkgs.qt6.qttools
        pkgs.qt6.qtwayland
        pkgs.SDL2
        pkgs.sdl3
        pkgs.sndio
        pkgs.stb
        pkgs.udev
        pkgs.vulkan-headers
        pkgs.vulkan-tools
        pkgs.vulkan-utility-libraries
        pkgs.wayland
        pkgs.wayland-protocols
        pkgs.libxcb
        pkgs.xcbutil
        pkgs.xcbutilkeysyms
        pkgs.xcbutilwm
        pkgs.zlib
      ];
    })

    (pkgs.stdenv.mkDerivation {
      pname = "BBLauncher";
      version = "1.0.0";
      src = bblauncher;
      nativeBuildInputs = [
        pkgs.cmake
        pkgs.pkg-config
        pkgs.qt6.wrapQtAppsHook
      ];
      buildInputs = [
        pkgs.alsa-lib
        pkgs.ffmpeg
        pkgs.fmt
        pkgs.glslang
        pkgs.jack2
        pkgs.libedit
        pkgs.libevdev
        pkgs.libpng
        pkgs.libpulseaudio
        pkgs.libxkbcommon
        pkgs.openal
        pkgs.openssl
        pkgs.qt6.qtbase
        pkgs.qt6.qtmultimedia
        pkgs.qt6.qttools
        pkgs.qt6.qtwayland
        pkgs.qt6.qtwebview
        pkgs.SDL2
        pkgs.sdl3
        pkgs.sndio
        pkgs.stb
        pkgs.udev
        pkgs.vulkan-headers
        pkgs.vulkan-tools
        pkgs.vulkan-utility-libraries
        pkgs.wayland
        pkgs.wayland-protocols
        pkgs.libxcb
        pkgs.xcbutil
        pkgs.xcbutilkeysyms
        pkgs.xcbutilwm
        pkgs.zlib
      ];
    })
  ];
}
