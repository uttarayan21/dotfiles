{...}: {
  services.mautrix-discord = {
    enable = true;
    settings = {
      homeserver = {
        address = "http://localhost:6167";
        domain = "darksailor.dev";
      };
      appservice.public = {
        prefix = "/public";
        external = "https://matrix.darksailor.dev/public";
      };
      bridge.permissions = {
        "darksailor.dev" = "user";
        "@servius:darksailor.dev" = "admin";
      };
    };
  };
}
