{pkgs, ...}: {
  programs.neomutt = {
    enable = true;
    vimKeys = true;
    editor = "nvim";
    sidebar = {
      enable = true;
    };
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
}
