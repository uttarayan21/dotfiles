{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./tailscale.nix
  ];
  programs = {
    home-manager.enable = true;
    bash.enable = true;
    helix = {
      enable = true;
      package = pkgs.evil-helix;
    };
  };
  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    packages = with pkgs; [
      _1password-cli
      just
    ];
    stateVersion = "24.11";
    activation.tailscale-service = let
      tailscale_service = pkgs.writeText "tailscaled.service" (builtins.replaceStrings ["/usr/bin/tailscaled"] ["${pkgs.tailscale}/bin/tailscaled"] (builtins.readFile ./tailscaled.service));
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        run echo cp ${tailscale_service} /etc/systemd/system/tailscaled.service
      '';
  };
}
