{pkgs, ...}: {
  home.packages = with pkgs; [
    (prismlauncher.override {
      additionalPrograms = [ffmpeg zenity];
      jdks = [
        # graalvm-ce
        zulu8
        zulu17
        zulu
      ];
    })
  ];
}
