{device, ...}: {
  programs.himalaya = {
    enable = true;
  };
  accounts.email.accounts.fastmail.himalaya = {
    enable = true;
    settings = {
      downloads-dir = "${device.home}/Mail";
      backend.type = "maildir";
      backend.root-dir = "~/Mail";
    };
  };
}
