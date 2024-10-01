# {
#   devices,
#   inputs,
#   deploy-rs,
# }: {
#   mkNode = {
#     device,
#     target,
#     config,
#   }: {
#     hostname = device.name;
#     profiles.system = {
#       user = device.user;
#       path = deploy-rs.lib.${device.system}.activate.${target} config;
#     };
#   };
#   nodes-x86_64-linux = builtins.map (device:
#     mkNode {
#       device = device;
#       target = "nixos";
#       config = self.nixosConfigurations.${device.name};
#     })
#   nixos_devices;
#   nodes-aarch64-darwin = builtins.map (device:
#     mkNode {
#       device = device;
#       target = "darwin";
#       config = self.darwinConfigurations.${device.name};
#     });
#   deploy = {
#     nodes = nodes-x86_64-linux ++ nodes-aarch64-darwin;
#   };
#
#   # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
#   # checks = {
#   #   x86_64-linux = deploy-rs.lib.x86_64-linux.deployChecks self.deploy;
#   # };
# }
