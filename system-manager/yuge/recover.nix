{pkgs, ...}: let
  nixPath = "/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin";
  recover = pkgs.writeShellApplication {
    name = "yuge-recover";
    runtimeInputs = with pkgs; [coreutils systemd];
    text = ''
      if [ "$EUID" -ne 0 ]; then
        exec sudo -- "$0" "$@"
      fi

      install -d -m 0755 /etc/ssh/sshd_config.d
      cat > /etc/ssh/sshd_config.d/50-nix-path.conf <<EOF
      SetEnv PATH=${nixPath}
      EOF
      chmod 0644 /etc/ssh/sshd_config.d/50-nix-path.conf

      install -d -m 0755 /etc/sudoers.d
      cat > /etc/sudoers.d/50-nix-path <<EOF
      Defaults secure_path="${nixPath}"
      EOF
      chmod 0440 /etc/sudoers.d/50-nix-path

      systemctl reload sshd || systemctl restart sshd
      systemctl start nix-daemon.service || true
      systemctl start system-manager-path.service || true

      echo "yuge-recover: bootstrap restored. Run 'deploy -s .#yuge' from your dev machine."
    '';
  };
in {
  environment.etc."yuge-recover" = {
    source = "${recover}/bin/yuge-recover";
    mode = "0755";
  };
}
