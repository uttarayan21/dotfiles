{...}: {
  services.remmina = {
    enable = true;
    systemdService.enable = true;
    addRdpMimeTypeAssoc = true;
  };
}
