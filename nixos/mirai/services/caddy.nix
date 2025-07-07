{
  pkgs,
  lib,
  ...
}: {
  services = {
    caddy = {
      enable = true;
      # package = pkgs.caddy.withPlugins {
      #   plugins = ["github.com/caddy-dns/hetzner@c1104f8d1e376a062bce86cd53025c2187a6be45"];
      #   hash = "sha256-9ea0CfOHG7JhejB73HjfXQpnonn+ZRBqLNz1fFRkcDQ=";
      # };
    };
  };
}
