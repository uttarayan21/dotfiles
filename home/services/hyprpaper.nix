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
  in {
    enable = device.is "ryu";
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = device.monitors.primary;
          path = wallpapers.skull;
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
