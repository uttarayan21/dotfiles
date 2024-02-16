{ pkgs, ... }:
let
  tmux-super-fingers =
    pkgs.tmuxPlugins.mkTmuxPlugin
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
  scratchpad = pkgs.writeShellScript "scratchpad" ''
    width=''\${2:-95%}
    height=''\${2:-95%}
    if [ "$(tmux display-message -p -F "#{session_name}")" = "scratch" ];then
        tmux detach-client
    else
        tmux popup -d '#{pane_current_path}' -xC -yC -w$width -h$height -E "tmux attach -t scratch || tmux new -s scratch"
    fi
  '';
in
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.nushellFull}/bin/nu";
    terminal = "tmux-256color";
    prefix = "C-q";
    historyLimit = 100000;
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      {
        plugin = tmux-super-fingers;
        extraConfig = "set -g @super-fingers-key o";
      }
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_default_text ""
        '';
      }
      {
        plugin = tmuxPlugins.battery;
        extraConfig = ''
          set -g @catppuccin_status_modules_right "battery application session date_time"
        '';
      }
    ];
    extraConfig = ''
      set -gw mode-keys vi
      set -g status-keys vi
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind-key -n C-\\ run-shell ${scratchpad}

      bind C-n next-window
      bind C-p previous-window
      bind C-q last-window

      if-shell 'uname | grep -q "Darwin"' { set -s copy-command "pbcopy" }
      if-shell 'uname | grep -q "Linux"' { set -s copy-command "wl-copy" }
    '';
  };
}
