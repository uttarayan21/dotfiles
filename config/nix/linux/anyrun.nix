{ inputs, pkgs, osConfig, ... }: {
  imports = [ inputs.anyrun.nixosModules.home-manager ];
  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        inputs.anyrun-nixos-options.packages.${pkgs.system}.default
        inputs.anyrun-hyprwin.packages.${pkgs.system}.default
        # inputs.anyrun-rink.packages.${pkgs.system}.default
        # rink
        applications
        websearch
        shell
        translate
        symbols
        kidex
      ];
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      height = { absolute = 0; };
      width = { absolute = 1000; };
      showResultsImmediately = true;
      maxEntries = 10;
      layer = "overlay";
    };

    extraConfigFiles = {
      "nixos-options.ron".text = let
        nixos-options = osConfig.system.build.manual.optionsJSON
          + "/share/doc/nixos/options.json";
        hm-options = inputs.home-manager.packages.${pkgs.system}.docs-json
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
        options = builtins.toJSON {
          ":nix" = [ nixos-options ];
          ":hm" = [ hm-options ];
        };

      in ''
        Config(
            options: ${options},
            max_entries: Some(10),
         )
      '';
      "shell.ron".text = ''
        Config(
            prefix: "",
            shell: None,
        )
      '';
      "websearch.ron".text = ''
        Config(
            prefix: "?",
            engines: [
            Google,
            DuckDuckGo,
            Custom (
                name: "Nix Packages",
                url: "search.nixos.org/packages?query={}"
            ),
            Custom (
                name: "docs.rs",
                url: "docs.rs/releases/search?query={}"
            ),
            Custom (
                name: "NixOS options",
                url: "search.nixos.org/options?query={}"
            ),
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
    };

    extraCss = ''
      window {
          color: #ffffff;
          background-color: rgba(15, 15, 15, .2);
          border-color: #000000;
      }

      entry {
          color: #ffffff;
          background-color: rgba(40, 40, 40, .98);
          padding: 14px;
          font-size: 30px;
          border-color: #000000;
          border-radius: 10px;
      }

      #plugin {
          color: #efefef;
          border-color: #000000;
          border-color: #000000;
          border-radius: 5px;
      }

      #main {
          color: #efefef;
          border-color: #000000;
          border-color: #000000;
          border-radius: 5px;
      }
    '';
  };
}
