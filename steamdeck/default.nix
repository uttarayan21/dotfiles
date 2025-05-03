{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./tailscale.nix
  ];
  programs = {home-manager.enable = true;};
  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    packages = with pkgs; [
      _1password-cli
      tailscale
      (nixvim.makeNixvim (import ../neovim))
    ];
    stateVersion = "24.11";
  };
}
