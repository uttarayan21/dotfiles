{...}: {
  services = {
    autossh = {
      sessions = [
        {
          name = "mirai-socks";
          extraArguments = "-N -D 1080";
          user = "fs0c131y";
        }
      ];
    };
  };
}
