{...}: {
  services = {
    prowlarr = {
      enable = true;
      settings = {
        auth = {
          authentication_enabled = true;
          authentication_method = "External";
        };
      };
    };
  };
}
