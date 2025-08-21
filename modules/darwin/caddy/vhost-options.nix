{cfg}: {
  config,
  lib,
  name,
  ...
}: let
  inherit (lib) literalExpression mkOption types;
in {
  options = {
    hostName = mkOption {
      type = types.str;
      default = name;
      description = "Canonical hostname for the server.";
    };

    serverAliases = mkOption {
      type = with types; listOf str;
      default = [];
      example = [
        "www.example.org"
        "example.org"
      ];
      description = ''
        Additional names of virtual hosts served by this virtual host configuration.
      '';
    };

    listenAddresses = mkOption {
      type = with types; listOf str;
      description = ''
        A list of host interfaces to bind to for this virtual host.
      '';
      default = [];
      example = [
        "127.0.0.1"
        "::1"
      ];
    };

    logFormat = mkOption {
      type = types.lines;
      default = ''
        output file ${cfg.logDir}/access-${lib.replaceStrings ["/" " "] ["_" "_"] config.hostName}.log
      '';
      defaultText = ''
        output file ''${config.services.caddy.logDir}/access-''${hostName}.log
      '';
      example = literalExpression ''
        mkForce '''
          output discard
        ''';
      '';
      description = ''
        Configuration for HTTP request logging (also known as access logs). See
        <https://caddyserver.com/docs/caddyfile/directives/log#log>
        for details.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional lines of configuration appended to this virtual host in the
        automatically generated `Caddyfile`.
      '';
    };
  };
}
