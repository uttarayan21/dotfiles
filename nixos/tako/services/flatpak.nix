{
  config,
  inputs,
  pkgs,
  ...
}: let
  repoRoot = "/var/lib/flatpak-repo";
  keysDir = "/var/lib/flatpak-repo-keys";
  signKey = "${keysDir}/sign-key.asc";
  gpgHome = "${keysDir}/.gnupg";
  signFingerprint = "E905BC5545AB37A8C0FBE2AB5FBDDDB5F4E40BBA";
  buildTools = with pkgs; [flatpak flatpak-builder ostree gnupg coreutils gnused gawk];
  baseEnv = {
    HOME = keysDir;
    GNUPGHOME = gpgHome;
  };
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

  environment.systemPackages = buildTools;

  services.caddy.virtualHosts."flatpak.darksailor.dev".extraConfig = ''
    root * ${repoRoot}
    file_server browse
  '';

  systemd.services.flatpak-repo-bootstrap = {
    description = "Initialize OSTree repo, import sign key, write client descriptors";
    after = ["sops-install-secrets.service"];
    wants = ["sops-install-secrets.service"];
    wantedBy = ["multi-user.target"];
    path = buildTools;
    environment = baseEnv;
    unitConfig.ConditionPathExists = "!${repoRoot}/darksailor.flatpakrepo";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      set -euo pipefail

      if [ ! -f ${repoRoot}/repo/config ]; then
        ostree --repo=${repoRoot}/repo init --mode=archive-z2
        ostree --repo=${repoRoot}/repo config set core.min-free-space-percent 0
      fi

      if ! gpg --list-secret-keys ${signFingerprint} >/dev/null 2>&1; then
        gpg --batch --import ${signKey}
      fi

      gpg --export ${signFingerprint} > ${repoRoot}/flatpak-pub.gpg
      gpg_b64=$(base64 -w0 ${repoRoot}/flatpak-pub.gpg)

      cat > ${repoRoot}/darksailor.flatpakrepo <<EOF
      [Flatpak Repo]
      Title=DarkSailor Flatpak Repo
      Url=https://flatpak.darksailor.dev/repo
      SuggestRemoteName=darksailor
      Homepage=https://flatpak.darksailor.dev
      GPGKey=$gpg_b64
      EOF

      cat > ${repoRoot}/dev.darksailor.SteamLaunchEditor.flatpakref <<EOF
      [Flatpak Ref]
      Title=Steam Launch Editor
      Name=dev.darksailor.SteamLaunchEditor
      Branch=master
      Url=https://flatpak.darksailor.dev/repo
      SuggestRemoteName=darksailor
      IsRuntime=false
      RuntimeRepo=https://flathub.org/repo/flathub.flatpakrepo
      GPGKey=$gpg_b64
      EOF
    '';
  };

  systemd.services.flatpak-sdk-install = {
    description = "Install Flathub freedesktop runtime + SDK + rust-stable extension";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    path = buildTools;
    unitConfig.ConditionPathExists = "!/var/lib/flatpak/runtime/org.freedesktop.Sdk.Extension.rust-stable/x86_64/25.08/active";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = "30min";
    };
    script = ''
      set -euo pipefail
      flatpak --system remote-add --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo
      flatpak --system install --noninteractive --assumeyes flathub \
        org.freedesktop.Platform//25.08 \
        org.freedesktop.Sdk//25.08 \
        org.freedesktop.Sdk.Extension.rust-stable//25.08
    '';
  };

  systemd.services.flatpak-publish-slo = {
    description = "Build & publish Steam Launch Editor flatpak from inputs.slo";
    after = ["flatpak-repo-bootstrap.service" "flatpak-sdk-install.service" "network-online.target"];
    wants = ["network-online.target"];
    requires = ["flatpak-repo-bootstrap.service" "flatpak-sdk-install.service"];
    wantedBy = ["multi-user.target"];
    path = buildTools;
    environment = baseEnv;
    restartTriggers = [inputs.slo.outPath];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = "1h";
    };
    script = ''
      set -euo pipefail
      work=$(mktemp -d)
      trap 'rm -rf "$work"' EXIT
      cp -a ${inputs.slo}/. "$work/"
      chmod -R u+w "$work"
      cd "$work/packaging/flatpak"

      flatpak-builder \
        --force-clean \
        --disable-rofiles-fuse \
        --repo=${repoRoot}/repo \
        --gpg-homedir=${gpgHome} \
        --gpg-sign=${signFingerprint} \
        "$work/build" \
        dev.darksailor.SteamLaunchEditor.yaml

      flatpak build-update-repo \
        --gpg-homedir=${gpgHome} \
        --gpg-sign=${signFingerprint} \
        --generate-static-deltas \
        ${repoRoot}/repo
    '';
  };
}
