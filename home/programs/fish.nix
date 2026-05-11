{
  pkgs,
  lib,
  device,
  config,
  ...
}:
{
  home.file = {
    ".config/fish/themes".source = pkgs.catppuccinThemes.fish + "/themes";
  };
  programs.fish = {
    enable = true;
    shellAbbrs = {
      vim = "nvim";
      vi = "nvim";
      nv = "neovide";
      g = "git";
      yy = "yazi";
      cd = "z";
      ls = "eza";
      cat = "bat";
      j = "just --choose";
      # t = "zellij a -c --index 0";
      t = "tmux";
      neorg = "nvim -c ':Neorg index'";
      neork = "nvim -c ':Neorg workspace Work'";
    };
    shellAliases = {
      g = "git";
    };
    shellInit = ''
      set fish_greeting
      yes | fish_config theme save "Catppuccin Mocha"
    '';
    # ${pkgs.spotify-player}/bin/spotify_player generate fish | source
    interactiveShellInit = ''
      if test -n "$TMUX"; ${lib.getExe pkgs.fastfetch} --logo-type kitty-icat; else ${lib.getExe pkgs.fastfetch}; end

      function __tv_git_repos
          printf "\n"
          set -l result (${lib.getExe pkgs.television} git-repos --inline --no-status-bar)
          if test -n "$result"
              commandline -t -- (string escape -- "$result")' '
          end
          printf "\033[A"
          commandline -f repaint
      end
      for mode in default insert
          bind --mode $mode ctrl-g __tv_git_repos
      end
      # ${pkgs.nb}/bin/nb todo undone
      ${lib.optionalString (device.isLinux && !device.isNix) "source /etc/profile.d/nix-daemon.fish"}
      ${lib.optionalString (device.is "ryu") ''
        if not set -q HYPRLAND_INSTANCE_SIGNATURE
            set -x HYPRLAND_INSTANCE_SIGNATURE (hyprctl instances | head -1 | cut -d ' ' -f2 | tr -d :)
        end
      ''}
    '';
  };
  home.shell.enableFishIntegration = true;

  # programs.bash = {
  #   enable = true;
  #   initExtra = ''
  #     if [[ $- == *i* && -z "$FISH_VERSION" ]]; then
  #       ${lib.getExe pkgs.fish}
  #     fi
  #   '';
  # };
}
// lib.optionalAttrs (!(device.is "tsuba")) {
  stylix.targets.fish.enable = false;
}
