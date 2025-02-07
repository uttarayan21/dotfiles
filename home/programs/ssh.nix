{
  pkgs,
  lib,
  device,
  ...
}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        user = "git";
        host = "github.com";
      };
      deoxys = {
        user = "servius";
        hostname = "deoxys";
        forwardAgent = true;
      };
      mirai = {
        user = "fs0c131y";
        hostname = "sh.darksailor.dev";
        forwardAgent = true;
      };
      ryu = {
        user = "servius";
        hostname = "ryu";
        forwardAgent = false;
      };
      kuro = {
        user = "fs0c131y";
        hostname = "kuro";
        forwardAgent = false;
      };
      shiro = {
        user = "servius";
        hostname = "shiro";
        forwardAgent = false;
      };
    };
    serverAliveInterval = 120;
    extraConfig =
      lib.strings.optionalString pkgs.stdenv.isDarwin
      ''
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      ''
      + lib.strings.optionalString (pkgs.stdenv.isLinux && !device.isServer) ''
        IdentityAgent ~/.1password/agent.sock
      '';
  };
}
