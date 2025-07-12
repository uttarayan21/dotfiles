{
  unstablePkgs,
  config,
  ...
}: let
  mkServarr = name: {
    ${name} = {
      enable = true;
      package = unstablePkgs.${name};
    };
    caddy.virtualHosts."${name}.tsuba.darksailor.dev".extraConfig = ''
      import hetzner
      reverse_proxy localhost:${builtins.toString config.services.${name}.settings.server.port}
    '';
  };
in {
  services =
    mkServarr "radarr"
    // mkServarr "sonarr"
    // mkServarr "prowlarr";
  # // mkServarr "readarr"
  # // mkServarr "bazarr";
}
