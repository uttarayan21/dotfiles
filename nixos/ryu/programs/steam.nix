{pkgs, ...}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    extraCompatPackages = [
      pkgs.proton-ge-bin
      pkgs.gamescope
      pkgs.gamescope-wsi
      pkgs.mangohud
      pkgs.vulkan-tools
    ];
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  environment.systemPackages = [
    pkgs.protonup-qt
    pkgs.vulkan-tools
    pkgs.gamescope
    pkgs.gamescope-wsi
  ];
}
