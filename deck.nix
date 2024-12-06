{
  pkgs,
  config,
  ...
}: {
  programs = {home-manager.enable = true;};
  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    packages = with pkgs; [
      _1password-cli
      tailscale
    ];
    stateVersion = "24.11";
  };
}
