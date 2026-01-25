{
  lib,
  device,
  cratesNix,
  ...
}:
lib.mkIf (!device.isServer) {
  home.file.".cargo/config.toml".text =
    # toml
    ''
      [alias]
      lldb = ["with", "rust-lldb", "--"]
      t = ["nextest", "run"]

      [net]
      git-fetch-with-cli = true

      [registries.kellnr]
      index = "sparse+https://crates.darksailor.dev/api/v1/crates/"

      [registry]
      global-credential-providers = ["cargo:token", "/etc/profiles/per-user/fs0c131y/bin/cargo-credential-1password --account my.1password.com"]
    '';
  home.packages = [
    (cratesNix.buildCrate "cargo-credential-1password" {})
  ];
}
