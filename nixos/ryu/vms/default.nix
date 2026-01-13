{pkgs, ...}: {
  virtualisation = {
    # libvirtd = {
    #   enable = true;
    #   qemu = {
    #     runAsRoot = true;
    #     swtpm.enable = true;
    #     # ovmf = {
    #     #   enable = true;
    #     # };
    #   };
    # };
    waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };
  };
  # imports = [
  #   ./win11.nix
  # ];
}
