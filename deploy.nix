{
  inputs,
  self,
  ...
}: {
  nodes = {
    mirai = {
      hostname = "mirai";
      profiles.system = {
        sshUser = "fs0c131y";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.mirai;
        user = "root";
      };
    };
    tsuba = {
      hostname = "tsuba.darksailor.dev";
      profiles.system = {
        sshUser = "servius";
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.tsuba;
        user = "root";
      };
    };
    ryu = {
      hostname = "ryu";
      profiles.system = {
        sshUser = "servius";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ryu;
        user = "root";
      };
    };
    kuro = {
      hostname = "kuro";
      interactiveSudo = true;
      profiles.system = {
        sshUser = "fs0c131y";
        path = inputs.deploy-rs.lib.aarch64-darwin.activate.darwin self.darwinConfigurations.kuro;
        user = "root";
      };
    };
    shiro = {
      hostname = "shiro";
      interactiveSudo = true;
      profiles.system = {
        sshUser = "servius";
        path = inputs.deploy-rs.lib.aarch64-darwin.activate.darwin self.darwinConfigurations.shiro;
        user = "root";
      };
    };
    deoxys = {
      hostname = "deoxys";
      profiles.system = {
        sshUser = "servius";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.deoxys;
        user = "root";
      };
    };
    deck = {
      hostname = "steamdeck";
      profiles.system = {
        sshUser = "deck";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager self.homeConfigurations.deck;
        user = "deck";
      };
    };
  };
}
