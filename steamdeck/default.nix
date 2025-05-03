{
  pkgs,
  config,
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
  };
}
