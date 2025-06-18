{pkgs, ...}: {
  services = {
    minecraft-server = {
      enable = true;
      openFirewall = true;
      eula = true;
      declarative = true;
      serverProperties = {
        online-mode = false;
        motd = "Servius's Minecraft Server";
        level-seed = "4504535438041489910";
        view-distance = 24;
      };
      package = let
        getJavaVersion = v: (builtins.getAttr "openjdk${toString v}" pkgs.javaPackages.compiler).headless;
      in
        pkgs.minecraft-server.override {
          url = "https://piston-data.mojang.com/v1/objects/6e64dcabba3c01a7271b4fa6bd898483b794c59b/server.jar";
          sha1 = "sha1-bmTcq7o8AacnG0+mvYmEg7eUxZs=";
          version = "1.21.6";
          jre_headless = getJavaVersion 21;
        };
    };
  };
}
