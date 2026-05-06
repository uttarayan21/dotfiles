{...}: {
  environment.etc."xdg/applications/moonlight-ryu.desktop" = {
    replaceExisting = true;
    text = ''
      [Desktop Entry]
      Name=Ryu Remote
      Comment=Stream ryu desktop via Sunshine
      Exec=flatpak run com.moonlight_stream.Moonlight stream --resolution 1280x800 --fps 60 --bitrate 30000 --video-codec av1 --display-mode fullscreen 100.78.171.80 Desktop
      Icon=com.moonlight_stream.Moonlight
      Terminal=false
      Type=Application
      Categories=Network;RemoteAccess;
    '';
  };
}
