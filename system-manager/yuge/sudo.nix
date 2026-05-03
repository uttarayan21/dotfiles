{...}: {
  environment.etc."sudoers.d/50-nix-path" = {
    mode = "0440";
    replaceExisting = true;
    text = ''
      Defaults secure_path="/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
    '';
  };
}
