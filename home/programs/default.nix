{
  pkgs,
  device,
  ...
}: {
  imports = [
    # ./eilmeldung.nix
    # ./bluetui.nix
    # ./goread.nix
    # ./helix.nix
    # ./iamb.nix
    # ./magika.nix
    # ./mpd.nix
    # ./mpris-scrobbler.nix
    # ./ncmpcpp.nix
    # ./newsboat.nix
    # ./nh.nix
    # ./ryujinx.nix
    # ./sxiv.nix
    # ./template.nix
    # ./tuifeed.nix
    # ./xh.nix
    # ./yt-dlp.nix
    # ./zellij.nix

    ../../modules

    ./1password-cli.nix
    ./aerc.nix
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
    ./calendar.nix
    ./carapace.nix
    ./cargo.nix
    ./cfcli.nix
    ./claude-code
    ./codex.nix
    ./ddcbacklight.nix
    ./deploy-rs.nix
    ./direnv.nix
    ./dust.nix
    ./dysk.nix
    ./eza.nix
    ./fastfetch.nix
    ./fd.nix
    ./file.nix
    ./fish.nix
    ./fnm.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gnupg.nix
    ./himalaya.nix
    ./hyprshade.nix
    ./jq.nix
    ./jujutsu.nix
    ./just.nix
    ./ncpamixer.nix
    ./neomutt.nix
    ./neovim.nix
    ./nixify.nix
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
    ./tea.nix
    ./television.nix
    ./tmux.nix
    ./uv.nix
    ./yazi.nix
    ./yq.nix
    ./zoxide.nix
  ];
}
