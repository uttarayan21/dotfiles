{
  config,
  pkgs,
  ...
}: {
  stylix.targets.firefox.profileNames = ["default"];
  programs.firefox = {
    enable = pkgs.stdenv.isLinux;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.default = {
      settings = {
        "extensions.autoDisableScopes" = 0;
        "extensions.enabledScopes" = 15;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "browser.ml.enable" = false;
        "browser.ml.chat.enabled" = false;
        "browser.ml.chat.shortcuts" = false;
        "browser.ml.chat.shortcuts.custom" = false;
        "browser.ml.chat.page" = false;
        "browser.ml.chat.sidebar" = false;
        "browser.ml.chat.menu" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.ml.linkPreview.optin" = false;
        "browser.tabs.groups.smart.enabled" = false;
        "browser.tabs.groups.smart.userEnabled" = false;
        "extensions.ml.enabled" = false;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.rdd-ffmpeg.enabled" = true;
        "media.av1.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "gfx.webrender.all" = true;
        "browser.urlbar.update2.engineAliasRefresh" = true;
      };
      userChrome = ''
        #urlbar[focused="true"],
        #urlbar[open] {
          position: fixed !important;
          top: 50% !important;
          left: 50% !important;
          transform: translate(-50%, -50%) !important;
          width: min(60vw, 900px) !important;
          max-width: 900px !important;
          min-height: 44px !important;
          z-index: 2147483647 !important;
          box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5) !important;
          border-radius: 12px !important;
        }

        #urlbar[open] > #urlbar-background {
          border-radius: 12px !important;
        }

        #urlbar[open] .urlbarView {
          border-radius: 0 0 12px 12px !important;
        }
      '';
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        augmented-steam
        clearurls
        floccus
        i-dont-care-about-cookies
        indie-wiki-buddy
        libredirect
        multi-account-containers
        onepassword-password-manager
        privacy-badger
        sponsorblock
        tridactyl
        ublock-origin
        violentmonkey
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
