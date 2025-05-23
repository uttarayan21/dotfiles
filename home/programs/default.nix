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
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./goread.nix
    ./helix.nix
    # ./ncmpcpp.nix
    # ./neomutt.nix
    # ./newsboat.nix
    ./nix-index.nix
    ./nushell.nix
    ./sops.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    # ./tuifeed.nix
    ./yazi.nix
    # ./zellij.nix
    ./zoxide.nix
    #./template.nix
    ./mpd.nix
    ./mpris-scrobbler.nix
  ];
  home.packages = with pkgs;
    [
      aria2
      nb
      (nixvim.makeNixvim (import ../../neovim))
      _1password-cli
      alejandra
      ast-grep
      bottom
      btop
      cachix
      deploy-rs
      dust
      fd
      file
      fzf
      gnupg
      gpg-tui
      jq
      just
      macchina
      p7zip
      pandoc
      pfetch-rs
      pkg-config
      ripgrep
      sd
      tldr
      vcpkg-tool
      yt-dlp
    ]
    ++ lib.optionals (!device.isServer) [
      clang
      cmake
      d2
      devenv
      go
      hasklig
      jujutsu
      monaspace
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      nerd-fonts.symbols-only
      qmk
      ttyper
      yarn
    ]
    ++ lib.optionals device.isLinux [
      dig
      gptfdisk
      handlr-regex
      handlr-xdg
      lsof
      ncpamixer
      rr
      sbctl
      usbutils
      ddcbacklight
    ]
    ++ lib.optionals device.isDarwin [];
}
