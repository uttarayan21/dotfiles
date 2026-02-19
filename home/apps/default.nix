{
  lib,
  device,
  ...
}:
lib.optionalAttrs device.hasGui {
  imports = [
    # ./audacity.nix
    # ./bottles.nix
    # ./cursor.nix
    # ./gimp.nix
    # ./guitarix.nix
    # ./ida.nix
    # ./jellyflix.nix
    # ./kicad.nix
    # ./lmstudio.nix
    # ./neovide.nix
    # ./openscad.nix
    # ./orcaslicer.nix
    # ./pcsx2.nix
    # ./prismlauncher.nix
    # ./rpcs3.nix
    # ./shadps4.nix
    # ./thunderbird.nix
    # ./tsukimi.nix
    # ./vial.nix
    # ./vlc.nix
    # ./vscode.nix

    ./affine.nix
    ./blueman.nix
    ./chromium.nix
    ./discord.nix
    ./firefox.nix
    ./ghostty.nix
    ./hyprpicker.nix
    ./kitty.nix
    ./matrix.nix
    ./mpv.nix
    ./nextcloud.nix
    ./obs-studio.nix
    ./slack.nix
    ./vicinae.nix
    ./wezterm.nix
    ./zathura.nix
    ./zed.nix
    ./zen.nix
  ];
}
