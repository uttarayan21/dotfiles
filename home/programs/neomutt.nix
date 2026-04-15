{
  pkgs,
  lib,
  device,
  ...
}: {
  config = lib.mkIf (!device.isServer) {
    home.packages = [pkgs.w3m];
    programs.notmuch = {
      enable = true;
      new.tags = ["new" "unread"];
      hooks = {
        preNew = ''
          ${pkgs.notmuch}/bin/notmuch tag +servius -- folder:fastmail/Inbox/Servius
          ${pkgs.notmuch}/bin/notmuch tag +hardware -- folder:fastmail/Inbox/Hardware
          ${pkgs.notmuch}/bin/notmuch tag +uber -- folder:fastmail/Inbox/Uber
          ${pkgs.notmuch}/bin/notmuch tag +spam -- folder:fastmail/Spam
          ${pkgs.notmuch}/bin/notmuch tag +spam -- folder:'gmail/[Gmail]/Spam'
          ${pkgs.notmuch}/bin/notmuch tag +sent -- folder:fastmail/Sent
          ${pkgs.notmuch}/bin/notmuch tag +sent -- folder:'gmail/[Gmail]/Sent Mail'
          ${pkgs.notmuch}/bin/notmuch tag +archive -- folder:fastmail/Archive
          ${pkgs.notmuch}/bin/notmuch tag +archive -- folder:'gmail/[Gmail]/All Mail'
        '';
      };
    };

    accounts.email.accounts = {
      fastmail = {
        notmuch = {
          enable = true;
        };
        imapnotify = {
          enable = true;
          boxes = ["Inbox" "Inbox/Servius" "Inbox/Hardware" "Inbox/Uber"];
          onNotify = "${pkgs.writeShellScript "mbsync-notify" ''
            ${pkgs.isync}/bin/mbsync $1
            ${pkgs.notmuch}/bin/notmuch new
            ${pkgs.libnotify}/bin/notify-send "New Mail" "New email in $1"
          ''} %s";
        };
      };
      gmail = {
        notmuch = {
          enable = true;
        };
        imapnotify = {
          enable = true;
          boxes = ["Inbox"];
          onNotify = "${pkgs.writeShellScript "mbsync-notify" ''
            ${pkgs.isync}/bin/mbsync $1
            ${pkgs.notmuch}/bin/notmuch new
            ${pkgs.libnotify}/bin/notify-send "New Mail" "New email in $1"
          ''} %s";
        };
      };
    };
    services.imapnotify = {
      enable = true;
      path = [pkgs.coreutils pkgs.isync pkgs.libnotify pkgs.notmuch];
    };
    programs.mbsync.enable = true;
    services.mbsync.enable = pkgs.stdenv.isLinux;
  };
}
