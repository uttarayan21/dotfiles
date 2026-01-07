{
  pkgs,
  config,
  lib,
  device,
  ...
}:
lib.optionalAttrs (!(device.is "tsuba")) {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "servius";
      user.email = builtins.elemAt config.accounts.email.accounts.fastmail.aliases 0;
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJfKKrX8yeIHUUury0aPwMY6Ha+BJyUR7P0Gqid90ik/";
      color.ui = true;
      core.editor = "nvim";
      core.pager = "${pkgs.delta}/bin/delta";
      interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
      delta.navigate = true;
      merge.conflictStyle = "diff3";
      diff.colorMoved = "default";
      push.autoSetupRemote = true;
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
