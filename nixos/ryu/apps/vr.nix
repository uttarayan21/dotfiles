{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wayvr
    # wlx-overlay-s
    # wayvr-dashboard
    # bs-manager
    monado-vulkan-layers
    # envision
  ];
}
