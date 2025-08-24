{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.spotybooty.nixosModules.default
  ];
  sops = {
    secrets."discord/token".owner = config.services.spotybooty.user;
  };
  services.spotybooty = {
    enable = true;
    logLevel = "info";
    tokenFile = config.sops.secrets."discord/token".path;
    openFirewall = true;
  };
}
