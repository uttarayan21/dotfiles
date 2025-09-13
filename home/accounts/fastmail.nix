{config, ...}: {
  sops = {
    secrets."accounts/mail/fastmail" = {};
  };
  accounts.email = {
    maildirBasePath = "Mail";
    accounts = {
      fastmail = rec {
        maildir = {
          path = "fastmail";
        };
        primary = true;
        address = "email@uttarayan.me";
        userName = address;
        realName = "Uttarayan Mondal";
        imap = {
          host = "imap.fastmail.com";
          port = 993;
          tls.enable = true;
          authentication = "login";
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
  services.mbsync.enable = true;
}
