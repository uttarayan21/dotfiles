  # environment.systemPackages = with pkgs; [nix neovim];
      experimental-features = "nix-command flakes auto-allocate-uids";
    package = pkgs.nixVersions.latest;