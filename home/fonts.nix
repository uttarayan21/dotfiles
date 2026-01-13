{
  pkgs,
  device,
  ...
}: {
  home.packages = with pkgs;
    lib.optionals (!device.isServer) [
      monaspace
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
    ];
}
