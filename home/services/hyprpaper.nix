{
  pkgs,
  device,
  config,
  ...
}: {
  # imports = [
  #   ../../modules/hyprpaper.nix
  # ];
  services.hyprpaper = let
    wallpapers = import ../../utils/wallhaven.nix {inherit pkgs;};
    nextcloudWallpapers = name: config.home.homeDirectory + "/Nextcloud/Wallpapers/" + name;
    silksongFleas = nextcloudWallpapers "silksong-fleas.jpg";
    silksongShadeLord = nextcloudWallpapers "silksong-shadelord.jpg";
  in rec {
    enable = device.is "ryu";
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
    settings.preload =
      wallpapers.all
      ++ pkgs.lib.mapAttrsToList (_: value: value) settings.wallpapers;
    settings.wallpapers = {
      "${device.monitors.primary}" = silksongShadeLord;
      "${device.monitors.secondary}" = wallpapers.frieren_3;
      "${device.monitors.tertiary}" = silksongFleas;
    };
  };
}
