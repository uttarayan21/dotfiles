{
  inputs,
  self,
  deploy-rs,
  ...
}: {
  nodes = {
    mirai = {
      hostname = "mirai.darksailor.dev";
      profiles.system = {
        sshUser = "fs0c131y";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.mirai;
        user = "root";
      };
    };
    tsuba = {
      hostname = "tsuba.darksailor.dev";
      profiles.system = {
        sshUser = "servius";
        path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.tsuba;
        user = "root";
      };
    };
    ryu = {
      hostname = "ryu";
      profiles.system = {
        sshUser = "servius";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ryu;
        user = "root";
      };
    };
    tako = {
      hostname = "tako.darksailor.dev";
      profiles.system = {
        sshUser = "servius";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.tako;
        user = "root";
      };
    };
    kuro = {
      hostname = "kuro";
      interactiveSudo = true;
      profiles.system = {
        sshUser = "fs0c131y";
        path = deploy-rs.lib.aarch64-darwin.activate.darwin self.darwinConfigurations.kuro;
        user = "root";
      };
    };
    shiro = {
      hostname = "shiro";
      interactiveSudo = true;
      profiles.system = {
        sshUser = "servius";
        path = deploy-rs.lib.aarch64-darwin.activate.darwin self.darwinConfigurations.shiro;
        user = "root";
      };
    };
    deck = {
      hostname = "sdeck";
      profiles.system = {
        sshUser = "deck";
        path = deploy-rs.lib.x86_64-linux.activate.home-manager self.homeConfigurations.deck;
        user = "deck";
      };
    };
  };
}
