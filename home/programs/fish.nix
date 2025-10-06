{
  pkgs,
  lib,
  device,
  config,
  ...
}: {
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
    };
    shellAliases =
      {
        g = "git";
      }
      // lib.optionalAttrs pkgs.stdenv.isLinux {
        kmpv = "mpv --vo-kitty-use-shm=yes --vo=kitty --really-quiet";
        smpv = "mpv --vo-sixel-buffered=yes --vo=sixel --profile=sw-fast";
      };
    shellInit = ''
      set fish_greeting
      yes | fish_config theme save "Catppuccin Mocha"
    '';
    # ${pkgs.spotify-player}/bin/spotify_player generate fish | source
    interactiveShellInit = ''
      ${pkgs.pfetch-rs}/bin/pfetch
      # ${pkgs.nb}/bin/nb todo undone
      ${lib.optionalString (device.isLinux && !device.isNix) "source /etc/profile.d/nix-daemon.fish"}
      ${lib.optionalString (device.is "ryu") ''
        if not set -q HYPRLAND_INSTANCE_SIGNATURE
            set -x HYPRLAND_INSTANCE_SIGNATURE (hyprctl instances | head -1 | cut -d ' ' -f2 | tr -d :)
        end
      ''}
    '';
  };
}
