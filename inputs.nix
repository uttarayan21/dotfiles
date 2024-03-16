{
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  nix-darwin = {
    url = "github:LnL7/nix-darwin";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  neovim-nightly-overlay = {
    url = "github:nix-community/neovim-nightly-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  anyrun = {
    # My fork of anyrun that allows up / down with <C-n> / <C-p>
    url = "github:uttarayan21/anyrun";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  anyrun-hyprwin = {
    url = "github:uttarayan21/anyrun-hyprwin";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  anyrun-nixos-options = {
    url = "github:n3oney/anyrun-nixos-options";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  anyrun-rink = {
    url = "github:uttarayan21/anyrun-rink";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  ironbar = {
    url = "github:JakeStanger/ironbar";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  lanzaboote = {
    url = "github:nix-community/lanzaboote";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  nixneovim = {
    # url = "github:nixneovim/nixneovim";
    url = "github:uttarayan21/NixNeovim";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # nixneovimplugins = {
  #   url = "github:NixNeovim/NixNeovimPlugins";
  #   inputs.nixpkgs.follows = "nixpkgs";
  # }
  rustaceanvim = {
    url = "github:mrcjkb/rustaceanvim";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  nix-index-database.url = "github:Mic92/nix-index-database";
  music-player = {
    url = "github:tsirysndr/music-player";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  nur.url = "github:nix-community/nur";

}
