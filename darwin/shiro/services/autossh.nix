{...}: {
  services = {
    autossh = {
      sessions = [
        {
          name = "mirai-socks";
          extraArguments = "-o 'IdentityAgent \"/Users/servius/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"' -N -D 1080";
          user = "fs0c131y";
        }
      ];
    };
  };
}
