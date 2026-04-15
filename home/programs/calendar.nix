{
  pkgs,
  lib,
  device,
  ...
}: {
  config = lib.mkIf (!device.isServer) {
    programs.khal = {
      enable = true;
      settings = {
        default = {
          # default_calendar = "fastmail";
        };
        view = {
          agenda_event_format = "{calendar-color}{cancelled}{start-end-time-style} {title}{repeat-symbol}{reset}";
        };
      };
    };
    programs.qcal.enable = true;
    programs.vdirsyncer.enable = true;
    services.vdirsyncer.enable = true;
    accounts.calendar.accounts.fastmail.qcal.enable = true;
  };
}
