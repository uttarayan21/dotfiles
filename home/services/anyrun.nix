{
  inputs,
  pkgs,
  device,
  osConfig,
  lib,
  ...
}: {
  disabledModules = ["programs/anyrun.nix"];
  imports = [inputs.anyrun.homeManagerModules.default];
  programs.anyrun = {
    enable = device.isDesktopLinux;
    package = inputs.anyrun.packages.${pkgs.system}.anyrun.overrideAttrs (finalAttrs: prevAttrs: {patches = [../../patches/ctrl-np.patch];});
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        inputs.anyrun-nixos-options.packages.${pkgs.system}.default
        inputs.anyrun-hyprwin.packages.${pkgs.system}.default
        # inputs.anyrun-rink.packages.${pkgs.system}.default
        rink
        applications
        websearch
        shell
        translate
        symbols
        kidex
      ];
      x = {fraction = 0.5;};
      y = {fraction = 0.3;};
      height = {absolute = 0;};
      width = {absolute = 1000;};
      showResultsImmediately = true;
      maxEntries = 10;
      layer = "overlay";
    };

    extraConfigFiles = {
      "nixos-options.ron".text = let
        nixos-options =
          pkgs.lib.optionalString device.isNix osConfig.system.build.manual.optionsJSON
          + "/share/doc/nixos/options.json";
        hm-options =
          inputs.home-manager.packages.${pkgs.system}.docs-json
          + "/share/doc/home-manager/options.json";
        # or alternatively if you wish to read any other documentation options, such as home-manager
        # get the docs-json package from the home-manager flake
        # hm-options = inputs.home-manager.packages.${pkgs.system}.docs-json + "/share/doc/home-manager/options.json";
        # options = builtins.toJSON {
        #   ":nix" = [nixos-options];
        #   ":hm" = [hm-options];
        #   ":something-else" = [some-other-option];
        #   ":nall" = [nixos-options hm-options some-other-option];
        # };
        options = builtins.toJSON ({
            ":hm" = [hm-options];
          }
          // (lib.mkIf device.isNix
            {":nix" = [nixos-options];}));
      in ''
        Config(
            options: ${options},
            max_entries: Some(10),
         )
      '';
      "shell.ron".text = ''
        Config(
            prefix: "!",
            shell: None,
        )
      '';
      "websearch.ron".text =
        /*
        ron
        */
        ''
          Config(
              prefix: "?",
              engines: [
              Google,
              Custom (
                  name: "Nix Packages",
                  url: "search.nixos.org/packages?query={}&channel=unstable"
              ),
              Custom (
                  name: "GitHub",
                  url: "github.com/search?q={}"
              ),
              Custom (
                  name: "docs.rs",
                  url: "docs.rs/releases/search?query={}"
              ),
              Custom (
                  name: "NixOS options",
                  url: "search.nixos.org/options?query={}"
              ),
              DuckDuckGo,
              ]
          )
        '';
      "rink.ron".text = ''
        Config(
            currency: Some("${
          builtins.toFile "currency.units" ''
            !category currencies "Currencies"
            usd                     USD
            inr                     INR
          ''
        }"),
        )
      '';
      "hyprwin.ron".text = ''
        Config(
            icons: {
                "org.wezfurlong.wezterm": "wezterm",
            }
        )
      '';
    };
  };
}
