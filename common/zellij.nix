{lib, ...}: {
  home.sessionVariables = {
    "ZELLIJ_AUTO_ATTACH" = "true";
    # "ZELLIJ_AUTO_EXIT" = "true";
  };
  programs.zellij = let
    mkBind = key: action:
      if builtins.isString action
      then "bind \"" + key + "\" {" + action + ";}"
      else "bind \"" + key + "\" {" + (lib.concatStringsSep ";" action) + ";}";

    mkBinds = binds: (lib.attrsets.mapAttrs' (key: action: lib.attrsets.nameValuePair (mkBind key action) []) binds);

    mkCommand = command: (mode: "${command} \"" + mode + "\"");
    # SwitchToMode = mode: "SwitchToMode \"" + mode + "\"";
    SwitchToMode = mkCommand "SwitchToMode";
    GoToTab = tab: "GoToTab ${toString tab}";
    ToggleTab = "ToggleTab";

    mkKeybinds = {
      normal ? null,
      locked ? null,
      resize ? null,
      pane ? null,
      move ? null,
      tab ? null,
      scroll ? null,
      search ? null,
      entersearch ? null,
      renametab ? null,
      renamepane ? null,
      session ? null,
      tmux ? null,
      # unbind ? null,
    } @ b:
      lib.attrsets.mapAttrs' (
        mode: keymaps:
          lib.attrsets.nameValuePair (
            if builtins.hasAttr "clear-defaults" keymaps && keymaps.clear-defaults == true
            then mode + " " + "clear-defaults=true"
            else mode
          ) (
            mkBinds (removeAttrs keymaps ["clear-defaults"])
          )
      )
      (lib.attrsets.filterAttrs (mode: keymaps: keymaps != {}) b);
    # mkUnbinds = bindings:
    #   if builtins.hasAttr "unbind" bindings
    #   then mkUnbind bindings.unbind
    #   else "";
    #
    # mkUnbind = key:
    #   if key.isString
    #   then "unbind \"" + key + "\""
    #   else lib.concatStringsSep " " (builtins.map ("\"" + key + "\"") key);
  in {
    enable = true;
    settings = {
      default_shell = "fish";
      pane_frames = false;
      theme = "catppuccin-mocha";
      default_layout = "compact";
      keybinds = mkKeybinds {
        normal = {
          clear-defaults = true;
          "Ctrl q" = SwitchToMode "Tmux";
        };
        tmux = {
          "0" = [(GoToTab 10) (SwitchToMode "Normal")];
          "1" = [(GoToTab 1) (SwitchToMode "Normal")];
          "2" = [(GoToTab 2) (SwitchToMode "Normal")];
          "3" = [(GoToTab 3) (SwitchToMode "Normal")];
          "4" = [(GoToTab 4) (SwitchToMode "Normal")];
          "5" = [(GoToTab 5) (SwitchToMode "Normal")];
          "6" = [(GoToTab 6) (SwitchToMode "Normal")];
          "7" = [(GoToTab 7) (SwitchToMode "Normal")];
          "8" = [(GoToTab 8) (SwitchToMode "Normal")];
          "9" = [(GoToTab 9) (SwitchToMode "Normal")];
          "Ctrl q" = [ToggleTab (SwitchToMode "Normal")];
          "*" = SwitchToMode "Normal";
        };
        scroll = {
          "g" = "ScrollToTop";
          "G" = "ScrollToBottom";
          "/" = "Search \"down\"";
          "?" = "Search \"up\"";
          "Ctrl u" = "HalfPageScrollUp";
          "Ctrl d" = "HalfPageScrollDown";
          "Ctrl f" = "PageScrollUp";
          "Ctrl b" = "PageScrollDown";
        };
      };
    };
    enableFishIntegration = true;
  };
}
