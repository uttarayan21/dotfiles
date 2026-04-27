{inputs, ...}: final: prev: {
  caddyWithCloudflare = inputs.nixpkgs.legacyPackages.${prev.stdenv.hostPlatform.system}.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/cloudflare@v0.2.2"];
    hash = "sha256-VBmICI1wklu02jmgDRmmlfNc9ftK7a74uF280xzx8uc=";
  };
}
