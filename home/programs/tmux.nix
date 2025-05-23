{pkgs, ...}: let
  scratchpad = pkgs.writeShellScript "scratchpad" ''
    width=''${2:-95%}
    height=''${2:-95%}
    if [ "$(tmux display-message -p -F "#{session_name}")" = "scratch" ];then
        tmux detach-client
    else
        tmux popup -d '#{pane_current_path}' -xC -yC -w$width -h$height -E "tmux new -A -s scratch -d -c ''$(pwd)"
    fi
  '';
in {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "C-q";
    historyLimit = 100000;
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.tmux-fzf
      tmuxPlugins.fzf-tmux-url
      tmuxPlugins.battery
      {
        plugin = tmuxPlugins.tmux-thumbs;
        extraConfig =
          if pkgs.stdenv.isDarwin
          then
            #tmux
            ''
              set -g @thumbs-command 'echo -n {} | pbcopy'
            ''
          else
            #tmux
            ''
              set -g @thumbs-command 'echo -n {} | wl-copy'
            '';
      }
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig =
          /*
          tmux
          */
          ''
            set -g @catppuccin_flavor 'mocha' # latte, frappe, macchiato or mocha
            set -g @catppuccin_window_status_style "rounded"
            set -g status-left ""
            set -g status-right "#{E:@catppuccin_status_application}"
            set -ag status-right "#{E:@catppuccin_status_session}"
            set -ag status-right "#{E:@catppuccin_status_uptime}"
            set -agF status-right "#{E:@catppuccin_status_battery}"
          '';
      }
    ];
    extraConfig =
      /*
      tmux
      */
      ''
        set -gw mode-keys vi
        set -g status-keys vi
        set -g allow-passthrough on
        set -g visual-activity off
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM
        set -sg escape-time 10
        set -sa terminal-features ',wezterm:RGB'
        set -g default-command "${pkgs.fish}/bin/fish";
        set -g default-shell "${pkgs.fish}/bin/fish";



        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        bind-key -n C-\\ run-shell "${pkgs.tmux-float}/bin/tmux-float toggle"

        bind o set status
        bind C-n next-window
        bind C-p previous-window
        bind C-q last-window

        if-shell 'uname | grep -q "Darwin"' { set -s copy-command "pbcopy" }
        if-shell 'uname | grep -q "Linux"' { set -s copy-command "wl-copy" }
      '';
  };
}
