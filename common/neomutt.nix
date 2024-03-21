{pkgs, ...}: {
  programs.neomutt = {
    enable = true;
    vimKeys = true;
    editor = "nvim";
    # sidebar = {
    # };
  };
}
