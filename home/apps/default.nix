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
    # ./neovide.nix
    # ./openscad.nix
    # ./pcsx2.nix
    # ./rpcs3.nix
    # ./thunderbird.nix
    # ./tsukimi.nix
    # ./vial.nix
    # ./vscode.nix

    ./blueman.nix
    ./chromium.nix
    ./discord.nix
    ./firefox.nix
    ./ghostty.nix
    ./hyprpicker.nix
    ./kitty.nix
    ./lmstudio.nix
    ./mpv.nix
    ./nextcloud.nix
    ./obs-studio.nix
    ./orcaslicer.nix
    ./prismlauncher.nix
    ./shadps4.nix
    ./slack.nix
    ./vicinae.nix
    ./vlc.nix
    ./wezterm.nix
    ./zathura.nix
    ./zed.nix
    ./zen.nix
  ];
}
