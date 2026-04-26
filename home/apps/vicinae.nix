{
  pkgs,
  lib,
  inputs,
  device,
  ...
}: {
  imports = [inputs.vicinae.homeManagerModules.default];
  services.vicinae = {
    enable = device.is "ryu";
    systemd = {
      enable = true;
      autoStart = true;
    };
  };
  home.packages = with pkgs;
    lib.optionals (device.is "ryu") [
      # pulseaudio
      playerctl
    ];

  # Vicinae caches xdg desktop entries at startup; restart after activation so
  # newly-added or changed .desktop files show up without manual intervention.
  home.activation.restartVicinae = lib.mkIf (device.is "ryu") (
    lib.hm.dag.entryAfter ["reloadSystemd"] ''
      ${pkgs.systemd}/bin/systemctl --user try-restart vicinae.service || true
    ''
  );
}
