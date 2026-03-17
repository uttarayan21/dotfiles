{pkgs, ...}: let
  neomutt-wrapped = pkgs.symlinkJoin {
    name = "neomutt";
    paths = [pkgs.neomutt];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/neomutt --set TERM xterm-direct
    '';
  };
in {
  programs.neomutt = {
    enable = true;
    package = neomutt-wrapped;
    vimKeys = true;
    editor = "nvim";
    sidebar = {
      enable = true;
    };
    checkStatsInterval = 60;
    extraConfig = ''
      # Catppuccin Mocha theme
      set color_directcolor = yes

      # Base colors
      color normal        #cdd6f4  #1e1e2e    # Text on Base
      color error         #f38ba8  #1e1e2e    # Red on Base
      color indicator     #1e1e2e  #f5c2e7    # Base on Pink (highlight)
      color status        #cdd6f4  #313244    # Text on Surface0
      color tilde         #6c7086  #1e1e2e    # Overlay0 on Base
      color tree          #cba6f7  #1e1e2e    # Mauve on Base
      color search        #1e1e2e  #f9e2af    # Base on Yellow

      # Index (message list)
      color index         #cdd6f4  #1e1e2e    # default
      color index         #a6e3a1  #1e1e2e  "~N"   # New messages - Green
      color index         #f38ba8  #1e1e2e  "~F"   # Flagged - Red
      color index         #f5c2e7  #1e1e2e  "~T"   # Tagged - Pink
      color index         #6c7086  #1e1e2e  "~D"   # Deleted - Overlay0

      # Headers
      color hdrdefault    #f5c2e7  #1e1e2e    # Pink
      color header        #f5c2e7  #1e1e2e  "^From:"
      color header        #f5c2e7  #1e1e2e  "^Subject:"

      # Body
      color quoted        #cba6f7  #1e1e2e    # Mauve
      color quoted1       #89b4fa  #1e1e2e    # Blue
      color quoted2       #94e2d5  #1e1e2e    # Teal
      color quoted3       #a6e3a1  #1e1e2e    # Green
      color quoted4       #f9e2af  #1e1e2e    # Yellow

      color signature     #6c7086  #1e1e2e    # Overlay0
      color attachment    #fab387  #1e1e2e    # Peach
      color body          #89b4fa  #1e1e2e  "[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+"  # Email - Blue
      color body          #89b4fa  #1e1e2e  "(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+"  # URLs - Blue
      color body          #a6e3a1  #1e1e2e  "(^|[[:space:]])\\*[^[:space:]]+\\*([[:space:]]|$)"  # *bold* - Green
      color body          #89dceb  #1e1e2e  "(^|[[:space:]])_[^[:space:]]+_([[:space:]]|$)"  # _underline_ - Sky
      color body          #cba6f7  #1e1e2e  "(^|[[:space:]])/[^[:space:]]+/([[:space:]]|$)"  # /italic/ - Mauve

      # Sidebar
      color sidebar_divider  #45475a  #1e1e2e
      color sidebar_new      #a6e3a1  #1e1e2e    # Green
      color sidebar_flagged  #f38ba8  #1e1e2e    # Red
      color sidebar_highlight #1e1e2e  #f5c2e7   # Base on Pink

      # Pager
      color progress      #cdd6f4  #313244    # Text on Surface0

      # Remove default mailboxes
      unmailboxes *

      # Notmuch virtual mailboxes
      virtual-mailboxes "Unread" "notmuch://?query=tag:unread"
      virtual-mailboxes "Inbox" "notmuch://?query=tag:inbox"
      virtual-mailboxes "Sent" "notmuch://?query=tag:sent"
      virtual-mailboxes "Archive" "notmuch://?query=tag:archive"
      virtual-mailboxes "Spam" "notmuch://?query=tag:spam"
      virtual-mailboxes "Flagged" "notmuch://?query=tag:flagged"
      virtual-mailboxes "Hardware" "notmuch://?query=tag:hardware"
      virtual-mailboxes "Servius" "notmuch://?query=tag:servius"
      virtual-mailboxes "Uber" "notmuch://?query=tag:uber"
      virtual-mailboxes "Fastmail" "notmuch://?query=folder:fastmail"
      virtual-mailboxes "Gmail" "notmuch://?query=folder:gmail"
    '';
  };
  programs.notmuch = {
    enable = true;
    new.tags = ["new" "unread"];
    hooks = {
      preNew = ''
        ${pkgs.notmuch}/bin/notmuch tag +servius -- folder:fastmail/Inbox/Servius
        ${pkgs.notmuch}/bin/notmuch tag +hardware -- folder:fastmail/Inbox/Hardware
        ${pkgs.notmuch}/bin/notmuch tag +uber -- folder:fastmail/Inbox/Uber
        ${pkgs.notmuch}/bin/notmuch tag +spam -- folder:fastmail/Spam
        ${pkgs.notmuch}/bin/notmuch tag +spam -- folder:'gmail/[Gmail]/Spam'
        ${pkgs.notmuch}/bin/notmuch tag +sent -- folder:fastmail/Sent
        ${pkgs.notmuch}/bin/notmuch tag +sent -- folder:'gmail/[Gmail]/Sent Mail'
        ${pkgs.notmuch}/bin/notmuch tag +archive -- folder:fastmail/Archive
        ${pkgs.notmuch}/bin/notmuch tag +archive -- folder:'gmail/[Gmail]/All Mail'
      '';
    };
  };

  accounts.email.accounts = {
    fastmail = {
      neomutt = {
        enable = true;
      };
      notmuch = {
        enable = true;
        neomutt.enable = false;
      };
      imapnotify = {
        enable = true;
        boxes = ["Inbox" "Inbox/Servius" "Inbox/Hardware" "Inbox/Uber"];
        onNotify = "${pkgs.writeShellScript "mbsync-notify" ''
          ${pkgs.isync}/bin/mbsync $1
          ${pkgs.libnotify}/bin/notify-send "New Mail" "New email in $1"
        ''} %s";
      };
    };
    gmail = {
      neomutt = {
        enable = true;
      };
      notmuch = {
        enable = true;
        neomutt.enable = false;
      };
      imapnotify = {
        enable = true;
        boxes = ["Inbox"];
        onNotify = "${pkgs.writeShellScript "mbsync-notify" ''
          ${pkgs.isync}/bin/mbsync $1
          ${pkgs.libnotify}/bin/notify-send "New Mail" "New email in $1"
        ''} %s";
      };
    };
  };
  services.imapnotify = {
    enable = true;
    path = [pkgs.coreutils pkgs.isync pkgs.libnotify];
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
