{...}: {
  homebrew = {
    enable = true;
    brews = [
      "docker-compose"
    ];
    casks = [
      "docker"
      "librewolf"
      "raycast"
      "kunkun" # Soon
      "lunar"
      "virtual-desktop-streamer"
      "kicad"
      "bambu-studio"
      "orcaslicer"
    ];
  };
}
