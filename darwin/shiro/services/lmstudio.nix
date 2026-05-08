{...}: {
  homebrew.casks = ["lm-studio"];
  services = {
    caddy.virtualHosts."lmstudio.shiro.darksailor.dev".extraConfig = ''
      import cloudflare
      reverse_proxy localhost:1234
    '';
  };
}
