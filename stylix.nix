{pkgs, ...}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.hasklug;
        name = "Hasklug Nerd Font Mono";
      };
    };
  };
}
