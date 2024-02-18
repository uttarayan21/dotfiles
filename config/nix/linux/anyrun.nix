{ inputs, pkgs, ... }: {
  imports = [ inputs.anyrun.nixosModules.home-manager ];
  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        inputs.anyrun-hyprwin.packages.${pkgs.system}.hyprwin
        rink
        applications
        websearch
        shell
        translate
        symbols
      ];
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      height = { absolute = 0; };
      width = { absolute = 1000; };
      showResultsImmediately = true;
      layer = "overlay";
    };

    extraConfigFiles = {
      "shell.ron".text = ''
        Config(
            prefix: "",
            shell: None,
        )
      '';
      "handlr.ron".text = ''
        Config(
            prefix: "",
            log: None,
        )
      '';
      "websearch.ron".text = ''
        Config(
            prefix: "?"
            engines: [Google, DuckDuckGo]
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
