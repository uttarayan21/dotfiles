{
  lib,
  device,
  ...
}:
lib.optionalAttrs device.hasGui {
  imports = [
    ./audacity.nix
    ./bottles.nix
    ./chromium.nix
    ./cursor.nix
    ./firefox.nix
    ./ghostty.nix
    ./gimp.nix
    ./guitarix.nix
    ./hyprpicker.nix
    ./kicad.nix
    ./kitty.nix
    ./mpv.nix
    ./neovide.nix
    ./obs-studio.nix
    ./openscad.nix
    ./orcaslicer.nix
    ./thunderbird.nix
    ./vlc.nix
    ./vscode.nix
    ./wezterm.nix
    ./zathura.nix
    ./zed.nix
    ./discord.nix
    ./slack.nix
    # ./rpcs3.nix
    ./pcsx2.nix
    # ./shadps4.nix
    # ./seafile.nix
    ./blueman.nix
    ./zen.nix
  ];
}
