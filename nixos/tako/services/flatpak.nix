{
  config,
  pkgs,
  ...
}: let
  repoRoot = "/var/lib/flatpak-repo";
  keysDir = "/var/lib/flatpak-repo-keys";
  signKey = "${keysDir}/sign-key.asc";
  gpgHome = "${keysDir}/.gnupg";
in {
  networking.domains.subDomains."flatpak.darksailor.dev" = {};

  sops.secrets."flatpak/signing_key_ascii" = {};
  sops.templates."flatpak-sign-key.asc" = {
    content = config.sops.placeholder."flatpak/signing_key_ascii";
    path = signKey;
    mode = "0400";
    owner = "root";
  };

  systemd.tmpfiles.rules = [
    "d ${repoRoot}      0755 root root - -"
    "d ${repoRoot}/repo 0755 root root - -"
    "d ${keysDir}       0700 root root - -"
    "d ${gpgHome}       0700 root root - -"
  ];

  environment.systemPackages = with pkgs; [flatpak flatpak-builder ostree gnupg git];

  services.caddy.virtualHosts."flatpak.darksailor.dev".extraConfig = ''
    root * ${repoRoot}
    file_server browse
  '';
}
