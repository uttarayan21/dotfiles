{
  pkgs,
  device,
  config,
  ...
}: {
  services.hyprpaper = let
    wallpapers = import ../../utils/wallhaven.nix {inherit pkgs;};
    nextcloudWallpapers = name: config.home.homeDirectory + "/Nextcloud/Wallpapers/" + name;
    silksongFleas = nextcloudWallpapers "silksong-fleas.jpg";
    silksongShadeLord = nextcloudWallpapers "silksong-shadelord.jpg";
  in {
    enable = device.is "ryu";
    settings = {
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
          path = silksongFleas;
          fit_mode = "cover";
        }
      ];
    };
  };
}
