{
  pkgs,
  device,
  ...
}: {
  imports = [
    # ./bluetui.nix
    # ./goread.nix
    # ./helix.nix
    # ./magika.nix
    # ./mpd.nix
    # ./mpris-scrobbler.nix
    # ./ncmpcpp.nix
    # ./newsboat.nix
    # ./nh.nix
    # ./ryujinx.nix
    # ./sxiv.nix
    # ./tea.nix
    # ./template.nix
    # ./tuifeed.nix
    # ./xh.nix
    # ./zellij.nix

    ../../modules

    ./1password-cli.nix
    ./aichat.nix
    ./alejandra.nix
    ./aria2.nix
    ./ast-grep.nix
    ./atuin.nix
    ./bat.nix
    ./binwalk.nix
    ./blobdrop.nix
    ./bottom.nix
    ./btop.nix
    ./cachix.nix
    ./carapace.nix
    ./cargo.nix
    ./ddcbacklight.nix
    ./deploy-rs.nix
    ./direnv.nix
    ./dust.nix
    ./dysk.nix
    ./eilmeldung.nix
    ./eza.nix
    ./fastfetch.nix
    ./fd.nix
    ./file.nix
    ./fish.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gnupg.nix
    ./himalaya.nix
    ./hyprshade.nix
    ./jq.nix
    ./just.nix
    ./ncpamixer.nix
    ./neomutt.nix
    ./neovim.nix
    ./nix-index.nix
    ./nushell.nix
    ./omnix.nix
    ./opencode.nix
    ./p7zip.nix
    ./pkg-config.nix
    ./retroarch.nix
    ./ripgrep.nix
    ./rustup.nix
    ./sd.nix
    ./sops.nix
    ./ssh.nix
    ./starship.nix
    ./television.nix
    ./tmux.nix
    ./uv.nix
    ./yazi.nix
    ./yt-dlp.nix
    ./zoxide.nix
    ./attic.nix
    ./cfcli.nix
  ];
}
