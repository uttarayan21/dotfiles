{
  lib,
  device,
  ...
}:
lib.optionalAttrs device.hasGui {
  imports = [
    # ./audacity.nix
    # ./blueman.nix
    # ./bottles.nix
    ./chromium.nix
    # ./cursor.nix
    ./discord.nix
    ./firefox.nix
    ./ghostty.nix
    ./gimp.nix
    # ./guitarix.nix
    ./hyprpicker.nix
    ./ida.nix
    # ./jellyflix.nix
    # ./kicad.nix
    ./kitty.nix
    ./lmstudio.nix
    ./mpv.nix
    # ./neovide.nix
    ./nextcloud.nix
    ./obs-studio.nix
    # ./openscad.nix
    ./orcaslicer.nix
    # ./pcsx2.nix
    ./prismlauncher.nix
    # ./rpcs3.nix
    # ./shadps4.nix
    ./slack.nix
    # ./thunderbird.nix
    # ./tsukimi.nix
    # ./vial.nix
    ./vicinae.nix
    ./vlc.nix
    ./vscode.nix
    ./wezterm.nix
    ./zathura.nix
    ./zed.nix
    ./zen.nix
  ];
}
