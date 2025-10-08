{
  pkgs,
  device,
  ...
}: {
  home.packages = with pkgs;
    []
    ++ lib.optionals (!device.isServer) [rustup clang]
    ++ lib.optionals device.isLinux []
    ++ lib.optionals device.isDarwin [];
}
