{pkgs, ...}: let
  theme = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/neomutt/refs/heads/main/neomuttrc";
    sha256 = "sha256:1q086p5maqwxa4gh6z8g7h3nfavdmkbql025ibdhglpz46hsq0hs";
  };
in {
  programs.neomutt = {
    enable = true;
    vimKeys = true;
    editor = "nvim";
    sidebar = {
      enable = true;
    };
    extraConfig = ''
      source ${theme}
    '';
  };
  programs.notmuch = {
    enable = true;
  };
  accounts.email.accounts.fastmail.neomutt = {
    enable = true;
  };
  accounts.email.accounts.fastmail.notmuch = {
    enable = true;
    neomutt.enable = true;
  };
  services.imapnotify = {
    enable = true;
    path = [pkgs.coreutils pkgs.isync pkgs.libnotify];
  };
  accounts.email.accounts.fastmail.imapnotify = {
    enable = true;
    boxes = ["Inbox"];
    onNotify = "${pkgs.writeShellScript "mbsync-notify" ''
      ${pkgs.isync}/bin/mbsync $1
      ${pkgs.libnotify}/bin/notify-send "New Mail" "New email in $1"
    ''} %s";
  };
}
