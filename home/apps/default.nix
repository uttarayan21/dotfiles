{
  lib,
  device,
  ...
}:
lib.optionalAttrs device.hasGui {
  imports = [
    # ./audacity.nix
    # ./cinny.nix
    # ./cursor.nix
    # ./discord.nix
    # ./gimp.nix
    # ./guitarix.nix
    # ./ida.nix
    # ./jellyflix.nix
    # ./kicad.nix
    # ./lichtfeld.nix
    # ./lmstudio.nix
    # ./neovide.nix
    # ./openscad.nix
    # ./orcaslicer.nix
    # ./pcsx2.nix
    # ./prismlauncher.nix
    # ./rpcs3.nix
    # ./thunderbird.nix
    # ./tsukimi.nix
    # ./vial.nix
    # ./vlc.nix
    # ./vscode.nix
    # ./zed.nix
    # ./zen.nix

    ./affine.nix
    ./bitwarden.nix
    ./blueman.nix
    ./calibre.nix
    ./chromium.nix
    ./firefox.nix
    ./ghostty.nix
    ./hyprpicker.nix
    ./kitty.nix
    ./localsend.nix
    ./matrix.nix
    ./moonlight.nix
    ./mpv.nix
    ./nextcloud.nix
    ./obs-studio.nix
    ./shadps4.nix
    ./slack.nix
    ./vicinae.nix
    ./wezterm.nix
    ./zathura.nix
    ./zen.nix
  ];
}
