{
  config,
  pkgs,
  ...
}: {
  sops = {
    secrets."accounts/mail/fastmail" = {};
    secrets."accounts/calendar/fastmail" = {};
  };
  accounts = {
    email = {
      maildirBasePath = "Mail";
      accounts = {
        fastmail = rec {
          maildir = {
            path = "fastmail";
          };
          primary = true;
          address = "email@uttarayan.me";
          aliases = ["servius@darksailor.dev"];
          userName = address;
          realName = "Uttarayan Mondal";
          imap = {
            host = "imap.fastmail.com";
            port = 993;
            tls.enable = true;
            # authentication = "login";
          };
          smtp = {
            host = "smtp.fastmail.com";
            port = 465;
            tls.enable = true;
          };
          imapnotify = {
            enable = true;
          };
          passwordCommand = ["cat" "${config.sops.secrets."accounts/mail/fastmail".path}"];
          mbsync = {
            enable = true;
            create = "both";
          };
        };
      };
    };
    calendar = {
      basePath = "Calendar";
      accounts = {
        fastmail = {
          remote = {
            url = "https://caldav.fastmail.com/dav/calendars/user/email@uttarayan.me";
            userName = "email@uttarayan.me";
            passwordCommand = ["cat" "${config.sops.secrets."accounts/calendar/fastmail".path}"];
            type = "caldav";
          };
          khal = {
            enable = true;
            addresses = ["email@uttarayan.me"];
          };
          vdirsyncer = {
            enable = true;
          };
        };
      };
    };
  };
  programs.mbsync.enable = true;
  services.mbsync.enable = pkgs.stdenv.isLinux;
  # accounts.email.accounts.<name>.mbsync.create
  # services.mbsync.enable = true;
}
