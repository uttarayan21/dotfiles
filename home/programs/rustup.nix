{
  pkgs,
  device,
  ...
}: {
  home.packages = with pkgs;
    []
    ++ lib.optionals (!device.isServer) [rustup]
    ++ lib.optionals device.isLinux []
    ++ lib.optionals device.isDarwin [];
}
