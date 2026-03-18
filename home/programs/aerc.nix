{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = [pkgs.w3m];

  programs.aerc = {
    enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
    extraConfig.ui = {
      styleset-name = "catppuccin-mocha";
      spinner = "⊒⊓⊣⊂📤";
      icon-unread = "📬";
      icon-read = "📭";
      icon-attachment = "📎";
    };
    extraConfig.pager = {
      pager = "nvim -R";
    };
    extraConfig.multipart-converters = {
      "text/html" = "w3m -I %{charset} -T text/html -cols %{width}";
    };
    extraConfig.filters = {
      "text/plain" = "colorize";
      "text/html" = "html | colorize";
      "text/calendar" = "calendar";
      "message/rfc822" = "colorize";
    };
  };
  accounts.email.accounts.fastmail.aerc = {
    enable = true;
  };
  accounts.email.accounts.gmail.aerc = {
    enable = true;
  };

  xdg.configFile."aerc/accounts.conf".text = ''
    [fastmail]
    aliases = servius@darksailor.dev
    copy-to = Sent
    default = Inbox
    from = Uttarayan Mondal <email@uttarayan.me>
    outgoing = smtps+plain://email@uttarayan.me@smtp.fastmail.com:465
    outgoing-cred-cmd = cat ${config.sops.secrets."accounts/mail/fastmail".path}
    postpone = Drafts
    source = maildir://~/Mail/fastmail

    [gmail]
    copy-to = Sent
    default = Inbox
    from = Uttarayan Mondal <uttarayan21@gmail.com>
    outgoing = smtps+plain://uttarayan21@gmail.com@smtp.gmail.com:465
    outgoing-cred-cmd = cat ${config.sops.secrets."accounts/mail/gmail".path}
    postpone = Drafts
    source = maildir://~/Mail/gmail

    [notmuch]
    from = Uttarayan Mondal <email@uttarayan.me>
    source = notmuch://~/Mail
    check-mail-cmd = mbsync -a
    check-mail-timeout = 30s
    exclude-tags = spam,deleted
    query-map = ~/.config/aerc/notmuch-query-map
    maildir-store = ~/Mail
    multi-file-strategy = act-one
  '';

  xdg.configFile."aerc/notmuch-query-map".text = ''
    inbox=tag:inbox and not tag:archived
    unread=tag:unread
    sent=tag:sent
    archive=tag:archive
    spam=tag:spam
    flagged=tag:flagged
    hardware=tag:hardware
    servius=tag:servius
    uber=tag:uber
  '';

  xdg.configFile."aerc/stylesets/catppuccin-mocha".text = ''
    *.default=true
    *.normal=true

    default.fg=#cdd6f4

    error.fg=#f38ba8
    warning.fg=#fab387
    success.fg=#a6e3a1

    tab.fg=#6c7086
    tab.bg=#181825
    tab.selected.fg=#cdd6f4
    tab.selected.bg=#1e1e2e
    tab.selected.bold=true

    border.fg=#11111b
    border.bold=true

    msglist_unread.bold=true
    msglist_flagged.fg=#f9e2af
    msglist_flagged.bold=true
    msglist_result.fg=#89b4fa
    msglist_result.bold=true
    msglist_*.selected.bold=true
    msglist_*.selected.bg=#313244

    dirlist_*.selected.bold=true
    dirlist_*.selected.bg=#313244

    statusline_default.fg=#9399b2
    statusline_default.bg=#313244
    statusline_error.bold=true
    statusline_success.bold=true

    selector_focused.bg=#313244

    completion_default.selected.bg=#313244

    [viewer]
    url.fg=#89b4fa
    url.underline=true
    header.bold=true
    signature.dim=true
    diff_meta.bold=true
    diff_chunk.fg=#89b4fa
    diff_chunk_func.fg=#89b4fa
    diff_chunk_func.bold=true
    diff_add.fg=#a6e3a1
    diff_del.fg=#f38ba8
    quote_*.fg=#6c7086
    quote_1.fg=#9399b2
  '';
}
