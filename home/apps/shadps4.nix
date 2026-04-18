{
  pkgs,
  lib,
  ...
}: let
  bblauncher = pkgs.fetchFromGitHub {
    owner = "rainmakerv3";
    repo = "BB_Launcher";
    rev = "Release15.01";
    sha256 = "sha256-L3G2DxchadDitZ2d9xE/Q60g9kGyDZjbwcYKth1e/Ww=";
    fetchSubmodules = true;
  };
in {
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.shadps4
    pkgs.shadps4-qt

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
