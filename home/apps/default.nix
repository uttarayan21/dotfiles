{
  lib,
  device,
  ...
}:
lib.optionalAttrs device.hasGui {
  imports = [
    # ./audacity.nix
    ./blueman.nix
    # ./bottles.nix
    ./chromium.nix
    # ./cursor.nix
    ./discord.nix
    ./firefox.nix
    ./ghostty.nix
    ./gimp.nix
    # ./guitarix.nix
    ./hyprpicker.nix
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
    # ./rpcs3.nix
    # ./shadps4.nix
    ./slack.nix
    # ./thunderbird.nix
    # ./tsukimi.nix
    # ./vial.nix
    ./vlc.nix
    ./vscode.nix
    ./wezterm.nix
    ./zathura.nix
    ./zed.nix
    ./zen.nix
  ];
}
