{...}: {
  services.terraria = {
    enable = true;
    autoCreatedWorldSize = "large";
    secure = true;
    openFirewall = true;
    password = "foobar12";
  };
}
