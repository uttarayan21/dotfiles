{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    (pkgs.tailscale.overrideAttrs (old: {
      postInstall =
        old.postInstall
        + ''
          cp -r $out/lib $out/etc
        '';
    }))
  ];
}
