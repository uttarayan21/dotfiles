{ device, pkgs, ... }: {
  programs.firefox = {
    enable = device.isLinux;
    profiles.default = {
      userChrome = let
        csshacks = pkgs.fetchFromGitHub {
          owner = "MrOtherGuy";
          repo = "firefox-csshacks";
          rev = "master";
          sha256 = "sha256-r5CKOOcRWZQzYA9M6j7m2CAulOQItCuWsTSNGOYN87w=";
        };
      in ''
        @import url(${csshacks}/chrome/tabs_on_bottom.css);
        @import url(${csshacks}/chrome/toolbars_below_content.css);
      '';
    };
    nativeMessagingHosts = [ pkgs.tridactyl-native ];
  };
}
