{...}: {
  services = {
    minecraft-server = {
      enable = true;
      openFirewall = true;
      eula = true;
    };
  };
}
