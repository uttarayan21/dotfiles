{
  device,
  pkgs,
  stablePkgs,
  ...
}: {
  stylix.targets.firefox.profileNames = ["default"];
  programs.firefox = {
    enable = pkgs.stdenv.isLinux;
    profiles.default = {
      settings = {
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.rdd-ffmpeg.enabled" = true;
        "media.av1.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "gfx.webrender.all" = true;
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        augmented-steam
        clearurls
        floccus
        i-dont-care-about-cookies
        indie-wiki-buddy
        keepa
        libredirect
        onepassword-password-manager
        privacy-badger
        sponsorblock
        tridactyl
        ublock-origin
        violentmonkey
        youtube-recommended-videos
      ];
      search = {
        force = true;
        default = "ddg";
        engines = {
          mynixos = {
            name = "My NixOS";
            urls = [
              {
                template = "https://mynixos.com/search?q={searchTerms}";
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@nx"];
          };
          hm = {
            name = "Home Manager Options";
            urls = [
              {
                template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
              }
            ];
            definedAliases = ["@hm"];
          };
          nv = {
            name = "NixVim";
            urls = [
              {
                template = "https://nix-community.github.io/nixvim/search";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@nv"];
          };
          lib = {
            name = "Lib.rs";
            urls = [
              {
                template = "https://lib.rs/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@lib"];
          };
          searchix = {
            name = "Searchix";
            urls = [
              {
                template = "https://searchix.ovh/?query={searchTerms}";
              }
            ];
            definedAliases = ["sx"];
          };
        };
      };
    };
    nativeMessagingHosts = [pkgs.tridactyl-native];
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      FeatureRecommendations = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      SkipOnboarding = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
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
