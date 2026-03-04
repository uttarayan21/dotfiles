{...}: {
  programs.fish = {
    enable = true;
    generateCompletions = true;
  };
  stylix.targets.fish.enable = false;
}
