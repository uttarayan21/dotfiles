{
  lib,
  device,
  cratesNix,
  ...
}: let
  cargo-credential-1password = cratesNix.buildCrate "cargo-credential-1password" {};
in
  lib.mkIf (!device.isServer) {
    home.file.".cargo/config.toml".text =
      # toml
      ''
        [alias]
        lldb = ["with", "rust-lldb", "--"]
        t = ["nextest", "run"]
        pkgs = ["metadata", "--no-deps", "--format-version", "1"]

        [net]
        git-fetch-with-cli = true

        [registries.kellnr]
        index = "sparse+https://crates.darksailor.dev/api/v1/crates/"

        [registry]
        global-credential-providers = ["cargo:token", "${lib.getExe cargo-credential-1password} --account my.1password.com"]
      '';
    home.packages = [
      cargo-credential-1password
    ];
  }
