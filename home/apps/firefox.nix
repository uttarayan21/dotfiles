{
  device,
  pkgs,
  ...
}: let
  config = {
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
    nativeMessagingHosts = [pkgs.tridactyl-native];
    policies = {
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      FeatureRecommendations = false;
      SkipOnboarding = true;
      Preferences = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = {
          Value = true;
          Status = "default";
        };
        "browser.urlbar.suggest.calculator" = {
          Value = true;
          Status = "default";
        };
        "extensions.quarantinedDomains.enabled" = {
          Value = false;
          Status = "default";
        };
      };
      FirefoxHome = {
        "Search" = true;
        "TopSites" = false;
        "SponsoredTopSites" = false;
        "Highlights" = false;
        "Pocket" = false;
        "SponsoredPocket" = false;
        "Snippets" = false;
        "Locked" = false;
      };
    };
  };
in {
  programs.librewolf = config // {package = pkgs.firefox-nightly;};
  programs.firefox = config;
}
