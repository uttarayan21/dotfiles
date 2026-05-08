{inputs, ...}: final: prev: {
  caddyWithCloudflare = inputs.nixpkgs.legacyPackages.${prev.stdenv.hostPlatform.system}.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
    hash = "sha256-J0HWjCPoOoARAxDpG2bS9c0x5Wv4Q23qWZbTjd8nW84=";
  };
}
