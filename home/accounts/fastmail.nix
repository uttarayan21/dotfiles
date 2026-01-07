{
  config,
  pkgs,
  ...
}: {
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
  programs.mbsync.enable = true;
  services.mbsync.enable = pkgs.stdenv.isLinux;
  # accounts.email.accounts.<name>.mbsync.create
  # services.mbsync.enable = true;
}
