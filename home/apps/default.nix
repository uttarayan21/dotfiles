{
  lib,
  device,
  ...
}:
lib.optionalAttrs device.hasGui {
  imports = [
    ./bambu-studio.nix
    ./cursor.nix
    ./firefox.nix
    ./ghostty.nix
    ./guitarix.nix
    ./kitty.nix
    ./mpv.nix
    ./obs-studio.nix
    ./vlc.nix
    ./vscode.nix
    ./wezterm.nix
    ./zathura.nix
    ./zed.nix
    ./gimp.nix
  ];
}
