{
  lib,
  pkgs,
  ...
}: {
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
    enableFishIntegration = true;
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

                    format_left  "{mode}#[fg=#89B4FA,bg=#181825,bold] {session}#[bg=#181825] {tabs}"
                    format_right "{command_kubectx}#[fg=#424554,bg=#181825]::{command_kubens}{datetime}"
                    format_space "#[bg=#181825]"

                    mode_normal          "#[bg=#89B4FA] "
                    mode_tmux            "#[bg=#ffc387] "
                    mode_default_to_mode "tmux"

                    tab_normal               "#[fg=#6C7086,bg=#181825] {index} {name} {fullscreen_indicator}{sync_indicator}{floating_indicator}"
                    tab_active               "#[fg=#9399B2,bg=#181825,bold,italic] {index} {name} {fullscreen_indicator}{sync_indicator}{floating_indicator}"
                    tab_fullscreen_indicator "□ "
                    tab_sync_indicator       "  "
                    tab_floating_indicator   "󰉈 "

                    command_kubectx_command  "kubectx -c"
                    command_kubectx_format   "#[fg=#6C7086,bg=#181825,italic] {stdout}"
                    command_kubectx_interval "2"

                    command_kubens_command  "kubens -c"
                    command_kubens_format   "#[fg=#6C7086,bg=#181825]{stdout} "
                    command_kubens_interval "2"

                    datetime          "#[fg=#9399B2,bg=#181825] {format} "
                    datetime_format   "%A, %d %b %Y %H:%M"
                    datetime_timezone "Asia/Kolkata"
                }
            }
        }
      '';
  };
}
