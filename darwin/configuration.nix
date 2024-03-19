{ pkgs, ... }: {
  imports = [ ./yabai.nix ./skhd.nix ];

  environment.systemPackages = with pkgs; [ nix neovim ];
  nix = {
    settings = {
      experimental-features = "nix-command flakes repl-flake";
      max-jobs = 8;
      trusted-users = [ "root" "fs0c131y" ];
    };
    extraOptions = ''
      build-users-group = nixbld
      extra-nix-path = nixpkgs=flake:nixpkgs
    '';
    package = pkgs.nix;
  };

  # security.pam.enableSudoTouchIdAuth = true;
  # system.patches = [
  #   (pkgs.writeText "pam-reattach.patch"
  #     # diff
  #     ''
  #       new file mode 100644
  #       index 0000000..e4293c0
  #       --- /dev/null
  #       +++ b/etc/pam.d/sudo_local
  #       @@ -0,0 +1,3 @@
  #       +# sudo_local: local config file which survives system update and is included for sudo
  #       +# uncomment following line to enable Touch ID for sudo
  #       +auth       optional     ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
  #     '')
  # ];

  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;

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
