{
  pkgs,
  device,
  ...
}: {
  imports = [
    ./yabai.nix
    ./skhd.nix
  ];

  environment.systemPackages = with pkgs; [
    nix
    neovim
  ];
  nix = {
    settings = {
      experimental-features = "nix-command flakes repl-flake";
      max-jobs = 8;
      trusted-users = ["root" "fs0c131y"];
    };
    extraOptions = ''
      build-users-group = nixbld
      extra-nix-path = nixpkgs=flake:nixpkgs
    '';
    package = pkgs.nix;
  };

  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;

  nixpkgs.hostPlatform = device.system;
  services.nix-daemon.enable = true;
  system.stateVersion = 4;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  system.keyboard.swapLeftCommandAndLeftAlt = true;
  system.keyboard.userKeyMapping = [
    {
      # Right Command to Option
      HIDKeyboardModifierMappingSrc = 30064771303;
      HIDKeyboardModifierMappingDst = 30064771302;
    }
    {
      # Right Option to command
      HIDKeyboardModifierMappingSrc = 30064771302;
      HIDKeyboardModifierMappingDst = 30064771303;
    }
  ];
}
# {
#   description = "Example Darwin system flake";
#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
#     # home-manager.url = "github:nix-community/home-manager/master";
#     # home-manager.inputs.nixpkgs.follows = "nixpkgs";
#     nix-darwin.url = "github:LnL7/nix-darwin";
#     nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
#   };
#   outputs = inputs @ {
#     self,
#     nix-darwin,
#     nixpkgs,
#   }: let
#     configuration = {pkgs, ...}: {
#       # List packages installed in system profile. To search by name, run:
#       # $ nix-env -qaP | grep wget
#       environment.systemPackages = with pkgs; [
#         neovim
#         bat
#         ripgrep
#         fd
#         fish
#         nushellFull
#         tmux
#         wezterm
#         # yabai
#         nerdfonts
#       ];
#       # Auto upgrade nix package and the daemon service.
#       services.nix-daemon.enable = true;
#       # nix.package = pkgs.nix;
#       # Necessary for using flakes on this system.
#       nix = {
#         settings = {
#           experimental-features = "nix-command flakes repl-flake";
#           max-jobs = 8;
#         };
#         extraOptions = ''
#           build-users-group = nixbld
#           extra-nix-path = nixpkgs=flake:nixpkgs
#         '';
#         # keep-outputs = true
#         # keep-derivations = true
#       };
#       # Create /etc/zshrc that loads the nix-darwin environment.
#       # programs.zsh.enable = true;  # default shell on catalina
#       # programs.fish.enable = true;
#       # Set Git commit hash for darwin-version.
#       system.configurationRevision = self.rev or self.dirtyRev or null;
#       system.keyboard.enableKeyMapping = true;
#       system.keyboard.remapCapsLockToControl = true;
#       system.keyboard.swapLeftCommandAndLeftAlt = true;
#       system.keyboard.userKeyMapping = {
#         # Right Command to Option
#         HIDKeyboardModifierMappingSrc = 30064771303;
#         HIDKeyboardModifierMappingDst = 30064771302;
#         # Right Option to command
#         HIDKeyboardModifierMappingSrc = 30064771302;
#         HIDKeyboardModifierMappingDst = 30064771303;
#       };
#       fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["Hasklig" "Hack"];})];
#       system.defaults.finder.AppleShowAllExtensions = true;
#       system.defaults.dock.autohide = true;
#       # Used for backwards compatibility, please read the changelog before changing.
#       # $ darwin-rebuild changelog
#       system.stateVersion = 4;
#       # The platform the configuration will be used on.
#       nixpkgs.hostPlatform = "aarch64-darwin";
#       nix.package = pkgs.nix;
#     };
#   in {
#     # Build darwin flake using:
#     # $ darwin-rebuild build --flake .#simple
#     darwinConfigurations.Uttarayans-MacBook-Pro = nix-darwin.lib.darwinSystem {
#       # system = "aarch64-darwin";
#       pkgs = import nixpkgs {system = "aarch64-darwin";};
#       modules = [configuration];
#     };
#     # Expose the package set, including overlays, for convenience.
#     # darwinPackages = self.darwinConfigurations.Uttarayans-MacBook-Pro.pkgs;
#   };
# }

