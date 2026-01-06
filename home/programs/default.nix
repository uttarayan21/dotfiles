{
  pkgs,
  device,
  ...
}: {
  imports = [
    ../../modules
    ./aichat.nix
    ./atuin.nix
    ./bat.nix
    ./carapace.nix
    ./ddcbacklight.nix
    ./direnv.nix
    ./eilmeldung.nix
    ./eza.nix
    ./fastfetch.nix
    ./fish.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./himalaya.nix
    ./hyprshade.nix
    ./ncpamixer.nix
    ./neomutt.nix
    ./neovim.nix
    ./nix-index.nix
    ./nushell.nix
    ./opencode.nix
    ./rustup.nix
    ./sops.nix
    ./ssh.nix
    ./starship.nix
    ./television.nix
    ./tmux.nix
    ./uv.nix
    ./yazi.nix
    ./yt-dlp.nix
    ./zoxide.nix

    # ./bluetui.nix
    # ./goread.nix
    # ./helix.nix
    # ./magika.nix
    # ./mpd.nix
    # ./mpris-scrobbler.nix
    # ./ncmpcpp.nix
    # ./neomutt.nix
    # ./neovim.nix
    # ./newsboat.nix
    # ./nh.nix
    # ./omnix.nix
    # ./retroarch.nix
    # ./ryujinx.nix
    # ./sxiv.nix
    # ./tea.nix
    # ./template.nix
    # ./tuifeed.nix
    # ./xh.nix
    # ./zellij.nix
  ];
  home.packages = with pkgs;
    [
      _1password-cli
      alejandra
      aria2
      bottom
      btop
      cachix
      deploy-rs.deploy-rs
      dust
      fd
      file
      fzf
      gnupg
      jq
      just
      macchina
      p7zip
      pfetch-rs
      pkg-config
      ripgrep
      sd
    ]
    ++ lib.optionals (!device.isServer) [
      monaspace
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
    ]
    ++ lib.optionals device.isLinux []
    ++ lib.optionals device.isDarwin [];
}
