{...}: {
  services = {
    fail2ban = {
      enable = true;
      bantime = "7d"; # First ban = 7 days
      bantime-increment = {
        enable = true;
        multipliers = "1 99999"; # 2nd+ ban = effectively permanent
        maxtime = "99999d";
        overalljails = true;
      };
      ignoreIP = [
        "100.64.0.0/10" # Tailscale CGNAT range — covers all Tailnet devices
        "106.219.121.52"
        "106.219.122.125"
        "106.219.122.221"
      ];
      jails = {
        caddy-bots.settings = {
          enabled = true;
          filter = "caddy-bots";
          logpath = "/var/log/caddy/access-git.darksailor.dev.log";
          findtime = 600;
          maxretry = 3;
          bantime = "7d";
          backend = "auto";
        };
        caddy-scrape.settings = {
          enabled = true;
          filter = "caddy-scrape";
          logpath = "/var/log/caddy/access-git.darksailor.dev.log";
          findtime = 60;
          maxretry = 30;
          bantime = "7d";
          backend = "auto";
        };
      };
    };
  };

  environment.etc = {
    "fail2ban/filter.d/caddy-bots.conf".text = ''
      [Definition]
      failregex = .*"remote_ip":"<HOST>".*"status":403
      datepattern = {^LN-BEG}^\{"level":"[^"]*","ts":(?:\d+\.\d+)
      ignoreregex =
    '';
    "fail2ban/filter.d/caddy-scrape.conf".text = ''
      [Definition]
      failregex = .*"remote_ip":"<HOST>".*"uri":"/[^"]*/(issues|pulls|find/commit|blame/commit|commits/commit|raw/commit|src/commit)[^"]*"
      datepattern = {^LN-BEG}^\{"level":"[^"]*","ts":(?:\d+\.\d+)
      ignoreregex = .*"User-Agent":\["git/
    '';
  };
}
