{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.nushell = {
    enable = true;
    shellAliases = {
      cd = "z";
      yy = "yazi";
      cat = "bat";
    };
    extraConfig = ''
      ${pkgs.pfetch-rs}/bin/pfetch
    '';
    package = pkgs.nushell;
    configFile.text = ''
      $env.config = {
          show_banner: false,
      }
    '';
  };
}
