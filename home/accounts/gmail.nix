{
  config,
  pkgs,
  ...
}: {
  sops.secrets."accounts/mail/gmail" = {};
  accounts.email.accounts.gmail = rec {
    maildir = {
      path = "gmail";
    };
    address = "uttarayan21@gmail.com";
    userName = address;
    realName = "Uttarayan Mondal";
    imap = {
      host = "imap.gmail.com";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "smtp.gmail.com";
      port = 465;
      tls.enable = true;
    };
    passwordCommand = ["cat" "${config.sops.secrets."accounts/mail/gmail".path}"];
    mbsync = {
      enable = true;
      create = "both";
    };
  };
}
