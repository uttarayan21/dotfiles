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
    ./bluetui.nix
    ./carapace.nix
    ./ddcbacklight.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./mpd.nix
    ./ncpamixer.nix
    ./nh.nix
    ./nix-index.nix
    ./nushell.nix
    ./omnix.nix
    ./ryujinx.nix
    ./sops.nix
    ./ssh.nix
    ./starship.nix
    ./sxiv.nix
    ./tea.nix
    ./tmux.nix
    ./tuifeed.nix
    ./yazi.nix
    ./yt-dlp.nix
    ./zoxide.nix
    ./television.nix

    # ./goread.nix
    # ./helix.nix
    # ./magika.nix
    # ./mpris-scrobbler.nix
    # ./ncmpcpp.nix
    # ./neomutt.nix
    # ./neovim.nix
    # ./newsboat.nix
    # ./template.nix
    # ./zellij.nix
  ];
  home.packages = with pkgs;
    [
      _1password-cli
      alejandra
      aria2
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
      nb
      (nixvim.makeNixvim (import ../../neovim))
      p7zip
      pandoc
      pfetch-rs
      pkg-config
      ripgrep
      sd
      tldr
      vcpkg-tool
    ]
    ++ lib.optionals (!device.isServer) [
      monaspace
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      nerd-fonts.symbols-only
    ]
    ++ lib.optionals device.isLinux []
    ++ lib.optionals device.isDarwin [];
}
