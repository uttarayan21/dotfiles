{
  device,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = device.hasGui;
    profiles.default = {
      userChrome =
        /*
        css
        */
        ''
          @import url(${pkgs.csshacks}/chrome/toolbars_below_content.css);
          @import url(${pkgs.csshacks}/chrome/scrollable_menupopups.css);
          @import url(${pkgs.csshacks}/chrome/linux_gtk_window_control_patch.css);
          @import url(${pkgs.csshacks}/chrome/window_control_placeholder_support.css);
        '';
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        privacy-badger
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
}
