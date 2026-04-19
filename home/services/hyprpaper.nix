{
  pkgs,
  device,
  config,
  ...
}: {
  services.hyprpaper = let
    wallpapers = import ../../utils/wallhaven.nix {inherit pkgs;};
    nextcloudWallpapers = name: config.home.homeDirectory + "/Nextcloud/Wallpapers/" + name;
    # silksongFleas = nextcloudWallpapers "silksong-fleas.jpg";

    # The artist https://www.bilibili.com/video/BV1s44y1S7MM/
    bocchiVertical = nextcloudWallpapers "bocchi-guitar.jpg";
    frieren = nextcloudWallpapers "frieren.png";
  in {
    enable = device.is "ryu";
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = device.monitors.primary;
          path = wallpapers.moon;
          fit_mode = "cover";
        }
        {
          monitor = device.monitors.secondary;
          path = frieren;
          fit_mode = "cover";
        }
        {
          monitor = device.monitors.tertiary;
          path = wallpapers.skull;
          fit_mode = "cover";
        }
      ];
    };
  };
}
