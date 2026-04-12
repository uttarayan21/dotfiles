{
  pkgs,
  inputs,
  device,
  config,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  programs.zen-browser.darwinDefaultsId = "org.mozilla.firefox.plist";
  programs.zen-browser = {
    enable = true;
    profiles.default = rec {
      settings = {
        "zen.window-sync.enabled" = true;
        "zen.welcome-screen.seen" = true;
        # Codec and hardware video decode support
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.rdd-ffmpeg.enabled" = true;
        "media.av1.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "gfx.webrender.all" = true;
      };
      containersForce = true;
      containers = {
        Personal = {
          color = "purple";
          icon = "fingerprint";
          id = 1;
        };
        Work = {
          color = "blue";
          icon = "briefcase";
          id = 2;
        };
        Shopping = {
          color = "yellow";
          icon = "dollar";
          id = 3;
        };
      };
      spacesForce = true;
      spaces = let
        containers = config.programs.zen-browser.profiles."default".containers;
      in {
        "Personal" = {
          id = "0b4dab19-9b39-4f2c-8ad1-0268d9fa2e49";
          icon = "👤";
          container = containers."Personal".id;
          position = 1000;
        };
        "Work" = {
          id = "8f687163-6b15-4c3c-885f-8ffe465b386f";
          icon = "💼";
          container = containers."Work".id;
          position = 2000;
        };
        "Shopping" = {
          id = "74f46a1b-cdd7-408c-98d7-382a2b11bd51";
          icon = "💸";
          container = containers."Shopping".id;
          position = 3000;
        };
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
            definedAliases = ["@nx"]; # Keep in mind that aliases defined here only work if they start with "@"
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
      pins = {
        dashboard = {
          id = "d163f090-67b7-47d2-8f76-7d638b9f742b";
          workspace = spaces.Personal.id;
          url = "https://dashboard.darksailor.dev";
          isEssential = true;
          position = 101;
        };
        github = {
          id = "db2f3e36-9279-4b8d-8b5d-52a90f34ea0d";
          workspace = spaces.Personal.id;
          url = "https://github.com";
          isEssential = true;
          position = 102;
        };
      };
      pinsForce = true;
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
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };
}
