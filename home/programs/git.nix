{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "uttarayan21";
    userEmail = "email@uttarayan.me";
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      core.pager = "${pkgs.delta}/bin/delta";
      interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
      delta.navigate = true;
      merge.conflictStyle = "diff3";
      diff.colorMoved = "default";
      push.autoSetupRemote = true;
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJfKKrX8yeIHUUury0aPwMY6Ha+BJyUR7P0Gqid90ik/";
      gpg.format = "ssh";
      commit.gpgsign = true;
      pull = {
        rebase = true;
      };
      "gpg \"ssh\"".program =
        if pkgs.stdenv.isDarwin
        then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else "${pkgs._1password-gui}/share/1password/op-ssh-sign";
    };
  };
}
