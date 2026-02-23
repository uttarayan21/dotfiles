{pkgs, ...}: let
  theme = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/neomutt/refs/heads/main/neomuttrc";
    sha256 = "sha256:1q086p5maqwxa4gh6z8g7h3nfavdmkbql025ibdhglpz46hsq0hs";
  };
in {
  programs.neomutt = {
    enable = true;
    vimKeys = true;
    editor = "nvim";
    sidebar = {
      enable = true;
    };
    extraConfig = ''
      source ${theme}
    '';
  };
  programs.notmuch = {
    enable = true;
  };
  accounts.email.accounts.fastmail.neomutt = {
    enable = true;
  };
  accounts.email.accounts.fastmail.notmuch = {
    enable = true;
    neomutt.enable = true;
  };
  services.imapnotify = {
    enable = true;
    path = [pkgs.coreutils pkgs.isync pkgs.libnotify];
  };
  accounts.email.accounts.fastmail.imapnotify = {
    enable = true;
    boxes = ["Inbox"];
    onNotify = "${pkgs.writeShellScript "mbsync-notify" ''
      ${pkgs.isync}/bin/mbsync $1
      ${pkgs.libnotify}/bin/notify-send "New Mail" "New email in $1"
    ''} %s";
  };
  programs.mbsync.enable = true;
  services.mbsync.enable = pkgs.stdenv.isLinux;

  # launchd.agents.mbsync = {
  #   enable = true;
  #   config = {
  #     # A label for the service
  #     Label = "dev.darksailor.atuin-daemon";
  #     # The command to run
  #     ProgramArguments = [
  #       "${pkgs.atuin}/bin/atuin"
  #       "daemon"
  #     ];
  #     # Run the service when you log in
  #     RunAtLoad = true;
  #     # Keep the process alive, or restart if it dies
  #     KeepAlive = true;
  #     # Log files
  #     StandardOutPath = "${device.home}/Library/Logs/atuin-daemon.log";
  #     StandardErrorPath = "${device.home}/Library/Logs/atuin-daemon.error.log";
  #   };
  # };
}
