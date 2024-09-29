{pkgs, ...}: {
  services = {
    skhd = {
      enable = true;
      skhdConfig = ''
        alt - return : ${pkgs.lib.getExe pkgs.kitty} --single-instance --directory ~ 
        # alt - return : $\{pkgs.wezterm}/bin/wezterm-gui
        shift + alt - return: pkill afplay

        # open mpv
        alt - m : open -na /Applications/mpv.app $(pbpaste)

        # close focused window
        # alt - w : yabai -m window --close

        alt - d : open -na "$(ls /Applications /System/Applications/ /System/Applications/Utilities/ | choose)"

        # focus window
        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east

        # alt - j : yabai -m window --focus prev
        # alt - k : yabai -m window --focus next

        # Float
        shift + alt - f: yabai -m window --toggle float
        alt - f: yabai -m window --toggle native-fullscreen

        # swap window
        # shift + alt - h : yabai -m window --swap west
        # shift + alt - j : yabai -m window --swap south
        # shift + alt - k : yabai -m window --swap north
        # shift + alt - l : yabai -m window --swap east

        # move window
        shift + alt - h : yabai -m window --warp west
        shift + alt - j : yabai -m window --warp south
        shift + alt - k : yabai -m window --warp north
        shift + alt - l : yabai -m window --warp east

        # restart skhd
        shift + alt - r : pkill skhd

        # fast focus desktop
        alt - 1 : yabai -m space --focus 1
        alt - 2 : yabai -m space --focus 2
        alt - 3 : yabai -m space --focus 3
        alt - 4 : yabai -m space --focus 4
        alt - 5 : yabai -m space --focus 5
        alt - 6 : yabai -m space --focus 6
        alt - 7 : yabai -m space --focus 7
        alt - 8 : yabai -m space --focus 8
        alt - 9 : yabai -m space --focus 9
        alt - 0 : yabai -m space --focus 10

        # Move window to desktop
        shift + alt - 1 : yabai -m window --space 1
        shift + alt - 2 : yabai -m window --space 2
        shift + alt - 3 : yabai -m window --space 3
        shift + alt - 4 : yabai -m window --space 4
        shift + alt - 5 : yabai -m window --space 5
        shift + alt - 6 : yabai -m window --space 6
        shift + alt - 7 : yabai -m window --space 7
        shift + alt - 8 : yabai -m window --space 8
        shift + alt - 9 : yabai -m window --space 9
        shift + alt - 0 : yabai -m window --space 10
      '';
    };
  };
}
