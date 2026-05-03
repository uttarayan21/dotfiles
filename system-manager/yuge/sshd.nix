{...}: {
  environment.etc."ssh/sshd_config.d/50-nix-path.conf" = {
    replaceExisting = true;
    text = ''
      SetEnv PATH=/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/bin
    '';
  };
}
