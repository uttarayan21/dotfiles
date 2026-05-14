{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.prismlauncher.override {
      additionalPrograms = with pkgs; [ffmpeg zenity];
      jdks = with pkgs; [
        zulu8
        zulu17
        zulu
        temurin-bin-25
      ];
    })
  ];
}
