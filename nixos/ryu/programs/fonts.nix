{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hasklug
    nerd-fonts.symbols-only
    monaspace
  ];
}
