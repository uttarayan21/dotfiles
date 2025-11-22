{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;
        swtpm.enable = true;
        # ovmf = {
        #   enable = true;
        # };
      };
    };
  };
  imports = [
    ./win11.nix
  ];
}
