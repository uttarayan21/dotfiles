{device, ...}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";

    flake = "/home/servius/Projects/dotfiles";
    # if device.isLinux
    # then "/home/servius/Projects/dotfiles"
    # else "/Users/fs0c131y/.local/share/dotfiles";
  };
}
