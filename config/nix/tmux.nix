{ pkgs, ... }:
let
  tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-super-fingers";
      version = "v1-2024-02-14";
      src = pkgs.fetchFromGitHub {
        owner = "artemave";
        repo = "tmux_super_fingers";
        rev = "518044ef78efa1cf3c64f2e693fef569ae570ddd";
        sha256 = "sha256-iKfx9Ytk2vSuINvQTB6Kww8Vv7i51cFEnEBHLje+IJw=";
      };
    };
in
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.nushellFull}/bin/nu";
    terminal = "tmux-256color";
    prefix = "C-q";
    historyLimit = 100000;
    plugins = with pkgs;
      [
        tmuxPlugins.better-mouse-mode
        {
          plugin = tmux-super-fingers;
          extraConfig = "set -g @super-fingers-key o";
        }
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'mocha'
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_status_modules_right ""
            set -g @catppuccin_status_modules_right "battery application session date_time"
          '';
        }
        {
          plugin = tmuxPlugins.battery;
          extraConfig = ''
            set -g @catppuccin_status_modules_right "application session user host date_time"
          '';
        }
      ];
    extraConfig = ''
      set -gw mode-keys vi
      set -g status-keys vi
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind h set status
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
      if-shell 'uname | grep -q "Darwin"' { set -s copy-command "pbcopy" }
      if-shell 'uname | grep -q "Linux"' { set -s copy-command "wl-copy" }
    '';
  };
}

