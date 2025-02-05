{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.
    fzf = {
    enable = true;
    package = pkgs.fzf;
    enableFishIntegration = true;
    tmux.enableShellIntegration = true;
  };
}
