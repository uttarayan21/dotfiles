{
  pkgs,
  device,
  config,
  ...
}: {
  imports = [
    ../../modules/hyprpaper.nix
  ];
  programs.hyprpaper = let
    wallpapers = import ../../utils/wallhaven.nix {inherit pkgs;};
    nextcloudWallpapers = name: config.home.homeDirectory + "/Nextcloud/Wallpapers/" + name;
    silksongFleas = nextcloudWallpapers "silksong-fleas.jpg";
  in {
    enable = true;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
    settings.preload =
      wallpapers.all
      ++ [
        silksongFleas
      ];
    settings.wallpapers = {
      # "${device.monitors.primary}" = silksongFleas;
      "${device.monitors.secondary}" = wallpapers.frieren_3;
      "${device.monitors.tertiary}" = wallpapers.hornet;
    };
  };
}
