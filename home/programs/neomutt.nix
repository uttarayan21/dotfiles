{pkgs, ...}: {
  programs.neomutt = {
    enable = false;
    vimKeys = true;
    editor = "nvim";
    # sidebar = {
    # };
  };
}
