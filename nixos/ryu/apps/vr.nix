{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    wayvr-dashboard
    # bs-manager
    monado-vulkan-layers
    # envision
  ];
}
