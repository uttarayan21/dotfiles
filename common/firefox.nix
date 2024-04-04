{
  device,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = device.hasGui;
    profiles.default = {
      userChrome = let
      # TODO: Move to subflake
        csshacks = pkgs.fetchFromGitHub {
          owner = "MrOtherGuy";
          repo = "firefox-csshacks";
          rev = "master";
          sha256 = "sha256-XJ+MTEADzOsCIh0I8EAxbtIpDHfMJsN68sKBy7/1l60=";
        };
      in
        /*
        css
        */
        ''
          /* @import url(${csshacks}/chrome/toolbars_below_content.css); */
          /* @import url(${csshacks}/chrome/scrollable_menupopups.css); */
          /* @import url(${csshacks}/chrome/linux_gtk_window_control_patch.css); */
        '';
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        privacy-badger
        bitwarden
        tridactyl
      ];
    };
    nativeMessagingHosts = [pkgs.tridactyl-native];
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
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
