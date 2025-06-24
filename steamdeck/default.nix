{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./tailscale.nix
    ../home/programs/ssh.nix
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
      just
    ];
    stateVersion = "24.11";
  };
}
