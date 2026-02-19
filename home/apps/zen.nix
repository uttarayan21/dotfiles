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
  programs.zen-browser = {
    enable = device.isLinux;
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
          id = "";
          icon = "👤";
          container = containers."Personal".id;
          position = 1000;
        };
        "Work" = {
          id = "00bdd434-e31b-4e2b-b8f5-fa7055631a64";
          icon = "💼";
          container = containers."Work".id;
          position = 2000;
        };
        "Shopping" = {
          id = "77452260-56e6-4c9e-8d5f-417958bc4fa4";
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
