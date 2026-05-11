{config, ...}: {
  imports = [../../modules/home/hass-cli.nix];

  sops.secrets."homeassistant/cli-token" = {};

  programs.hass-cli = {
    enable = true;
    server = "https://home.darksailor.dev";
    tokenFile = config.sops.secrets."homeassistant/cli-token".path;
  };

  home.shellAliases.ha = "hass-cli";
  programs.fish.shellAliases.ha = "hass-cli";
  programs.nushell.shellAliases.ha = "hass-cli";
}
