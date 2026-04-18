{inputs, ...}: final: prev: {
  caddyWithCloudflare = inputs.nixpkgs.legacyPackages.${prev.stdenv.hostPlatform.system}.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/cloudflare@v0.2.2"];
    hash = "sha256-7DGnojZvcQBZ6LEjT0e5O9gZgsvEeHlQP9aKaJIs/Zg=";
  };
}
