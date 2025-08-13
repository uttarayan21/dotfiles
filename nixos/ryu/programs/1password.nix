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
        .zen-wrapped
        .zen-beta-wrapped
        zen
        zen-beta
      ''; # or just "zen" if you use unwrapped package
      mode = "0755";
    };
  };
}
