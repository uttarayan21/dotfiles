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
    # fish.enable = true;
  };
  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    packages = with pkgs; [
      _1password-cli
      (nixvim.makeNixvim (import ../neovim))
    ];
    stateVersion = "24.11";
    activation.tailscale-service = let
      tailscale_service = pkgs.writeText "tailscaled.service" (builtins.replaceStrings ["/usr/bin/tailscaled"] ["${pkgs.tailscale}/bin/tailscaled"] (builtins.readFile ./tailscaled.service));
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        run cp ${tailscale_service} /etc/systemd/system/tailscaled.service
      '';
  };
}
