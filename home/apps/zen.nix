{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  programs.zen-browser = {
    enable = pkgs.stdenv.isLinux;
    profiles.default = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        privacy-badger
        violentmonkey
        tridactyl
        clearurls
        onepassword-password-manager
        ublock-origin
        i-dont-care-about-cookies
        keepa
        sponsorblock
      ];
    };
    policies = {
      DisablePocket = true;
      DisableTelemetry = true;
      FeatureRecommendations = false;
      SkipOnboarding = true;
    };
  };
}
