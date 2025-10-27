{...}: {
  programs. yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    # theme = lib.mkDefault builtins.fromTOML (builtins.readFile "${pkgs.catppuccinThemes.yazi}/themes/mocha.toml");
    settings = {
      plugin = {
        prepend_preloaders = [
          {
            name = "/run/user/1000/gvfs";
            run = "noop";
          }
        ];
      };
    };
  };
}
