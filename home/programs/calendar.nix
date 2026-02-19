{pkgs, ...}: {
  programs.khal.enable = true;
  programs.qcal.enable = true;
  programs.vdirsyncer.enable = true;
  accounts.calendar.accounts.fastmail.qcal.enable = true;
}
