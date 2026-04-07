{stablePkgs, ...}: {
  programs.bat = {
    enable = true;
    # extraPackages = with pkgs.bat-extras; [batman batgrep batwatch];
    package = stablePkgs.bat;
  };
}
