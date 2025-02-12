{
  lib,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    # "ZELLIJ_AUTO_ATTACH" = "true";
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
      # default_layout = "compact";
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
    enableFishIntegration = false;
  };
  xdg.configFile."zellij/layouts/default.kdl" = {
    text =
      /*
      kdl
      */
      ''
        layout {
            pane split_direction="vertical" {
                pane
            }

            pane size=1 borderless=true {
                plugin location="file:${pkgs.zellijPlugins.zjstatus}/bin/zjstatus.wasm" {
                    hide_frame_for_single_pane "true"

                    format_left  "{mode}#[fg=#89B4FA,bg=#181825,bold] {tabs}"
                    format_right "#[fg=#424554,bg=#181825]{session} on {datetime}"
                    format_space "#[bg=#181825]"

                    mode_normal          "#[fg=black,bg=#89B4FA] NORMAL #[fg=#87B4FA,bg=#181825]"
                    mode_tmux            "#[fg=black,bg=#FFC387] TMUX #[fg=#FFC387,bg=#181825]"
                    // mode_default_to_mode "tmux"

                    tab_normal              "#[fg=#181825,bg=#4C4C59] #[fg=#000000,bg=#4C4C59]{index}  {name} #[fg=#4C4C59,bg=#181825]"
                    tab_normal_fullscreen   "#[fg=#6C7086,bg=#181825] {index} {name} [] "
                    tab_normal_sync         "#[fg=#6C7086,bg=#181825] {index} {name} <> "
                    tab_active              "#[fg=#181825,bg=#ffffff,bold,italic] {index}  {name} #[fg=#ffffff,bg=#181825]"
                    tab_active_fullscreen   "#[fg=#9399B2,bg=#181825,bold,italic] {index} {name} [] "
                    tab_active_sync         "#[fg=#9399B2,bg=#181825,bold,italic] {index} {name} <> "

                    datetime          "#[fg=#9399B2,bg=#181825] {format}"
                    datetime_format   "%A, %d %b %Y %H:%M"
                    datetime_timezone "Asia/Kolkata"
                }
            }
        }
      '';
  };
}
