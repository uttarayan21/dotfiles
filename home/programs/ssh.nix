{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      tsuba = {
        user = "servius";
        hostname = "tsuba.darksailor.dev";
      };
      github = {
        user = "git";
        host = "github.com";
      };
      # mirai = {
      #   user = "fs0c131y";
      #   hostname = "mirai.darksailor.dev";
      #   forwardAgent = true;
      # };
      tako = {
        user = "servius";
        hostname = "tako.darksailor.dev";
        forwardAgent = true;
      };
      ryu = {
        user = "servius";
        hostname = "ryu.darksailor.dev";
        forwardAgent = true;
      };
      kuro = {
        user = "fs0c131y";
        hostname = "kuro";
        forwardAgent = false;
      };
      shiro = {
        user = "servius";
        hostname = "shiro";
        forwardAgent = true;
      };
      deck = {
        user = "deck";
        hostname = "steamdeck";
        forwardAgent = true;
      };
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        # compression = true;
        # HashKnownHosts = "no";
        serverAliveInterval = 60;
      };
    };
    extraConfig =
      lib.strings.optionalString (pkgs.stdenv.isDarwin && !device.isServer)
      ''
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      ''
      + lib.strings.optionalString (pkgs.stdenv.isLinux && !device.isServer) ''
        IdentityAgent ~/.1password/agent.sock
      '';
  };
  # // lib.mkIf (!(device.is "tsuba")) {
  #   enableDefaultConfig = false;
  # };
}
