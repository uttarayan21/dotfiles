{inputs, ...}: final: prev: {
  ddcbacklight = inputs.ddcbacklight.packages.${prev.stdenv.hostPlatform.system}.ddcbacklight;
  music-player-git = inputs.music-player.packages.${prev.stdenv.hostPlatform.system}.default;
}
