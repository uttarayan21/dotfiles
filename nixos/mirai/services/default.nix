{...}: {
  imports = [
    ./atuin.nix
    ./authelia.nix
    # ./home-assistant.nix
    # ./navidrome.nix
    # ./llama.nix
    # ./nextcloud.nix
    ./minecraft.nix
    ./jellyfin.nix
    ./vscode.nix
    ./tailscale.nix
    # ./ldap.nix
  ];
  services = {
    nix-serve = {
      enable = true;
    };
    fail2ban = {
      enable = true;
      bantime = "24h"; # Ban IPs for one day on the first ban
      bantime-increment = {
        enable = true; # Enable increment of bantime after each violation
        # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h"; # Do not ban for more than 1 week
        overalljails = true; # Calculate the bantime based on all the violations
      };
    };
    caddy = {
      enable = true;
    };
  };
}
