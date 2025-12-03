{...}: {
  homebrew = {
    enable = true;
    brews = [
      "docker-compose"
    ];
    casks = [
      "docker"
      "raycast"
      "lunar"
      "virtual-desktop-streamer"
      "kicad"
      "shapr3d"
      "orcaslicer"
      "zed"
      "zen"
    ];
  };
}
