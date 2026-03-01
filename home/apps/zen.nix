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
    profiles.default = {
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
        privacy-badger
        violentmonkey
        tridactyl
        clearurls
        onepassword-password-manager
        ublock-origin
        i-dont-care-about-cookies
        keepa
        sponsorblock
        floccus
      ];
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
    suppressXdgMigrationWarning = true;
  };
}
