{
  pkgs,
  device,
  ...
}: {
  programs.foot = {
    enable = device.is "ryu";
    server.enable = true;
    settings = {
      main = {
        shell = "${pkgs.fish.outPath}/bin/fish";
        # font = "Hasklug Nerd Font Mono:size=13";
        font = "Monaspace Krypton:size=13";
        initial-window-size-pixels = "1440x800";
      };
      colors = {
        foreground = "f8f8f2";
        background = "000000";
        alpha = 0.8;

        "136" = "af8700";

        regular0 = "21222c";
        regular1 = "ff5555";
        regular2 = "50fa7b";
        regular3 = "f1fa8c";
        regular4 = "bd93f9";
        regular5 = "ff79c6";
        regular6 = "8be9fd";
        regular7 = "f8f8f2";

        bright0 = "6272a4";
        bright1 = "ff6e6e";
        bright2 = "69ff94";
        bright3 = "ffffa5";
        bright4 = "d6acff";
        bright5 = "ff92df";
        bright6 = "a4ffff";
        bright7 = "ffffff";
      };
    };
  };
}
