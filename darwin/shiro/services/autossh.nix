{...}: {
  services = {
    autossh = {
      enable = true;
      sessions = {
        "mirai" = {
          name = "mirai-socks";
          extraArguments = "-N -D 1080 -M 0";
          user = "fs0c131y";
        };
      };
    };
  };
}
