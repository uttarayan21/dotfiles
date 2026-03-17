{config, ...}: {
  programs.aerc = {
    enable = true;
  };
  accounts.email.accounts.fastmail.aerc = {
    enable = true;
  };
  accounts.email.accounts.gmail.aerc = {
    enable = true;
  };
}

