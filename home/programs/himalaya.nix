{
  config,
  lib,
  device,
  ...
}: {
  config = lib.mkIf (!device.isServer) {
    programs.himalaya = {
      enable = true;
    };
    accounts.email.accounts.fastmail.himalaya = {
      enable = true;
      settings = {
        downloads-dir = "${config.home.homeDirectory}/Mail/fastmail";
        backend.type = "maildir";
        backend.root-dir = "${config.home.homeDirectory}/Mail/fastmail";
      };
    };
  };
}
