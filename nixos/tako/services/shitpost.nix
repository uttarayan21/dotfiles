{pkgs, ...}: let
  src = pkgs.fetchgit {
    url = "https://git.darksailor.dev/servius/adarkdayinmylife.public";
    # repo = "adarkdayinmy.life";
    rev = "68d972f68cab8f68916b94df05b7ab6a7da4a1da";
    sha256 = "sha256-EVis06rmHq1jJK0FVsbgi7TOru7GtEUpbx0PjU2AKEo=";
  };
in {
  services.caddy.virtualHosts."adarkdayinmy.life".extraConfig = ''
    root * ${src}/
    file_server
  '';
}
