{...}: {
  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["servius"];
    };
  };
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        firefox
        .firefox-wrapped
      '';
      mode = "0755";
    };
  };
}
