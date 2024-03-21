{pkgs, ...}: {
  programs.ncmpcpp = {
    enable = true;
    bindings =
      pkgs.lib.attrsets.mapAttrsToList (key: value: {
        key = key;
        command = value;
      }) {
        j = "scroll_down";
        k = "scroll_up";
        J = ["select_item" "scroll_down"];
        K = ["select_item" "scroll_up"];
      };
    package = pkgs.ncmpcpp;
  };
}
