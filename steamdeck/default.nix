{
  pkgs,
  config,
  home-manager,
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
    activation.tailscale-service = home-manager.dag.entryAfter ["writeBoundary"] ''
      ${builtins.replaceStrings (builtins.readFile ./tailscaled.service)}
    '';
  };
}
