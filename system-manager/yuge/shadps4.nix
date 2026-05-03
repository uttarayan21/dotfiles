{...}: {
  environment.etc."xdg/applications/bloodborne.desktop" = {
    replaceExisting = true;
    text = ''
      [Desktop Entry]
      Name=Bloodborne
      Comment=Bloodborne via shadPS4
      Exec=/home/deck/.local/bin/shadps4 -g /home/deck/Games/Bloodborne/CUSA00900/eboot.bin
      Icon=net.shadps4.shadPS4
      Terminal=false
      Type=Application
      Categories=Game;
    '';
  };

  environment.etc."xdg/applications/shadps4-qt.desktop" = {
    replaceExisting = true;
    text = ''
      [Desktop Entry]
      Name=shadPS4 (Qt)
      Comment=shadPS4 PS4 emulator — Qt launcher
      Exec=/home/deck/.local/bin/shadps4-qt
      Icon=net.shadps4.shadPS4
      Terminal=false
      Type=Application
      Categories=Game;
    '';
  };
}
