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
    bocchiVertical = nextcloudWallpapers "bocchi-vertical.jpg";
    silksongShadeLord = nextcloudWallpapers "silksong-shadelord.jpg";
  in {
    enable = device.is "ryu";
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = device.monitors.primary;
          path = silksongShadeLord;
          fit_mode = "cover";
        }
        {
          monitor = device.monitors.secondary;
          path = wallpapers.frieren_3;
          fit_mode = "cover";
        }
        {
          monitor = device.monitors.tertiary;
          path = bocchiVertical;
          fit_mode = "cover";
        }
      ];
    };
  };
}
