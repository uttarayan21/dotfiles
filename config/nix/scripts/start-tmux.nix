{ pkgs
, ...
}:
pkgs.writeShellScript "start-tmux" ''
  live_sessions=$(${pkgs.tmux}/bin/tmux list-sessions 2>/dev/null)
  all_sessions=$(${pkgs.findutils}/bin/find -L ~/.config/tmux/sessions -type f -executable  -printf '%f\n'| sort)
  TMUX_SESSIONS="$HOME/.config/tmux/sessions"
  # for some reason ~/.config/tmux/session doesn't work if made with quotes
  # TMUX_SESSIONS=$XDG_CONFIG_HOME/tmux/sessions
  if ! [ -z "$TMUX" ];then
  echo "Nested tmux sessions are a bad idea?"
  echo "If you want to really do this unset TMUX environment variable"
  exit 1
  fi
  IFS=$'\n'
  for live_session in $live_sessions;
  do
      live_session_name=$(echo $live_session | ${pkgs.coreutils}/bin/cut -d: -f1)
      if [ -z "''\${all_sessions##*$live_session_name*}" ];then # see https://stackoverflow.com/questions/229551/how-to-check-if-a-string-contains-a-substring-in-bash
          all_sessions="$(echo "$all_sessions" | sed "s/$live_session_name/$live_session/g")"
      else
          all_sessions="$(echo -e "$all_sessions\n$live_session")"
      fi
  done
  session=$(echo "''\$all_sessions" | ${pkgs.fzf}/bin/fzf)
  session_name=$(echo $session | cut -d: -f1)
  if [ -z "$session" ];then
      exit 0
  fi
  if ! [ -z "''\${session##*created*}" ];then
      if [ -x "$TMUX_SESSIONS/$session_name" ];then
          source $TMUX_SESSIONS/$session_name
      else
          echo $TMUX_SESSIONS/$session_name not found or is not executable
          exit 1
      fi
  fi
  if [ -z "''\${session##*attached*}" ];then
      read -r -p "The session is already attached somewhere else. Attach it here too ? (y/N): " choice
      if [ "$choice" == "y" ] || [ "$choice" == "Y" ];then
          ${pkgs.tmux}/bin/tmux attach-session -t$session_name
      fi
  else
      ${pkgs.tmux}/bin/tmux attach-session -t$session_name
  fi
''



