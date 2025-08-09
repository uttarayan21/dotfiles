{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./tailscale.nix
    ../home/programs/helix.nix
    ../home/programs/sops.nix
  ];
  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      settings = {
      };
    };
  };

  systemd.user.services = {
    nextcloudcmd = {
      Unit = {
        Description = "Nextcloud Client";
      };
      Service = {
        ExecStart = "${pkgs.nextcloud-client}/bin/nextcloudcmd -n /home/deck/Nextcloud https://cloud.darksailor.dev";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };

  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    packages = with pkgs; [
      _1password-cli
      just
    ];
    home.file.".ssh/rc".text = ''
      export PATH="/nix/var/nix/profiles/default/bin:$PATH"
    '';
    activation.tailscale-service = let
      tailscale_service = pkgs.writeText "tailscaled.service" (builtins.replaceStrings ["/usr/bin/tailscaled"] ["${pkgs.tailscale}/bin/tailscaled"] (builtins.readFile ./tailscaled.service));
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        run echo cp ${tailscale_service} /etc/systemd/system/tailscaled.service
      '';
    stateVersion = "24.11";
  };
}
