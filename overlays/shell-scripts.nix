{...}: final: prev: {
  handlr-xdg = final.pkgs.writeShellApplication {
    name = "xdg-open";
    runtimeInputs = [final.pkgs.handlr-regex];
    text = ''
      handlr open "$@"
    '';
  };
}
