{pkgs, ...}: {
  services = {
    minecraft-server = {
      enable = true;
      openFirewall = true;
      eula = true;
      declarative = true;
      whitelist = {
        "AbhinavSE" = "8b6c052e-69b3-4bee-b9dc-12eb94653c9e";
        "Serveus" = "79882fb6-d594-4073-a3d0-70a01d0abb67";
        "__Shun__" = "1c7a300f-98e4-402c-8741-432f3494bb25";
        "shashikant" = "20891e82-203c-4d04-9868-79a5879ecfc3";
      };
      serverProperties = {
        motd = "Servius's Minecraft Server";
        level-seed = "4504535438041489910";
        view-distance = 24;
        white-list = true;
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
