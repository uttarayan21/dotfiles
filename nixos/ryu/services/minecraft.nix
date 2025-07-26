{
  pkgs,
  inputs,
  config,
  ...
}: {
  sops = {
    secrets."minecraft/craftmine".owner = "minecraft";
    templates = {
      "craftmine.env".content = ''
        CRAFTMINE_RCON_PASSWORD=${config.sops.placeholder."minecraft/craftmine"}
      '';
    };
  };
  services = let
    whitelist = {
      "AbhinavSE" = "8b6c052e-69b3-4bee-b9dc-12eb94653c9e";
      "Serveus" = "79882fb6-d594-4073-a3d0-70a01d0abb67";
      "__Shun__" = "1c7a300f-98e4-402c-8741-432f3494bb25";
      "shashikant" = "20891e82-203c-4d04-9868-79a5879ecfc3";
    };
  in {
    minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      environmentFile = config.sops.templates."craftmine.env".path;
      servers.fabric = {
        inherit whitelist;
        enable = true;
        enableRcon = true;
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
      servers.craftmine = {
        inherit whitelist;
        enable = true;
        jvmOpts = "-Xmx4G -Xms4G";
        package = let
          getJavaVersion = v: (builtins.getAttr "openjdk${toString v}" pkgs.javaPackages.compiler).headless;
        in
          pkgs.minecraft-server.override {
            url = "https://piston-data.mojang.com/v1/objects/4527a9019e37e001770787e4523b505f79cac4c5/server.jar";
            sha1 = "sha1-RSepAZ434AF3B4fkUjtQX3nKxMU=";
            version = "25w14craftmine";
            jre_headless = getJavaVersion 21;
          };

        serverProperties = {
          enable-rcon = true;
          "rcon.password" = "@CRAFTMINE_RCON_PASSWORD@";
          motd = "Servius's Craftmine Server";
          server-port = 25569;
          white-list = true;
          view-distance = 32;
        };
      };
    };
  };
}
