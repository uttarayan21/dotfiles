{
  pkgs,
  inputs,
  ...
}: {
  services = let
    whitelist = {
      "AbhinavSE" = "8b6c052e-69b3-4bee-b9dc-12eb94653c9e";
      "Serveus" = "79882fb6-d594-4073-a3d0-70a01d0abb67";
      "__Shun__" = "1c7a300f-98e4-402c-8741-432f3494bb25";
      "shashikant" = "20891e82-203c-4d04-9868-79a5879ecfc3";
    };
  in {
    minecraft-servers = {
      enable = false;
      eula = true;
      openFirewall = true;
      servers.fabric = {
        inherit whitelist;
        enable = true;
        jvmOpts = "-Xmx4G -Xms4G";
        package = pkgs.fabricServers.fabric-1_21_1;
        serverProperties = {
          motd = "Servius's Fabric Minecraft Server";
          server-port = 25567;
          level-seed = "4504535438041489910";
          view-distance = 24;
          white-list = true;
        };
      };
    };
  };
}
