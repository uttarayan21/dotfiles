{inputs, ...} @ self: let
  # --- Shell / CLI utilities ---
  shell-scripts = final: prev: {
    handlr-xdg = final.pkgs.writeShellApplication {
      name = "xdg-open";
      runtimeInputs = [final.pkgs.handlr-regex];
      text = ''
        handlr open "$@"
      '';
    };
  };

  # --- Terminal multiplexers ---
  terminal = final: prev: {
    tmuxPlugins =
      prev.tmuxPlugins
      // {
        tmux-super-fingers = final.pkgs.tmuxPlugins.mkTmuxPlugin {
          pluginName = "tmux-super-fingers";
          version = "v1-2024-02-14";
          src = final.pkgs.fetchFromGitHub {
            owner = "artemave";
            repo = "tmux_super_fingers";
            rev = "518044ef78efa1cf3c64f2e693fef569ae570ddd";
            sha256 = "sha256-iKfx9Ytk2vSuINvQTB6Kww8Vv7i51cFEnEBHLje+IJw=";
          };
        };
      };
    tmux-float = inputs.tmux-float.packages.${prev.system}.default;
    zellijPlugins = {
      zjstatus = inputs.zjstatus.packages.${prev.system}.default;
    };
  };

  # --- System libraries ---
  system-libs = final: prev: {
    # Custom libfprint with CS9711 fingerprint reader support
    # https://github.com/archeYR/libfprint-CS9711/commits/cs9711-rebase/
    libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
      version = "git";
      src = final.fetchFromGitHub {
        owner = "archeYR";
        repo = "libfprint-CS9711";
        rev = "c2d163fbb06d33e80a5177815bb0b8ca2f01739f";
        sha256 = "sha256-JygOJ3SybXKR3CjLxLbAZDaYCl9LuQYDQfFC8Si5oaw";
      };
      buildInputs = oldAttrs.buildInputs ++ [final.nss_latest];
      nativeBuildInputs =
        oldAttrs.nativeBuildInputs
        ++ [
          final.opencv
          final.cmake
          final.doctest
        ];
    });
  };

  # --- Networking ---
  networking = final: prev: {
    caddyWithCloudflare = inputs.nixpkgs.legacyPackages.${final.system}.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.2"];
      hash = "sha256-biQdtiscdmrwP6VUsuXmZrvcdewl+g50kdmab5lhE0s=";
    };
  };

  # --- Media ---
  media = final: prev: {
    ddcbacklight = inputs.ddcbacklight.packages.${prev.system}.ddcbacklight;
    music-player-git = inputs.music-player.packages.${prev.system}.default;
  };

  # --- macOS-specific ---
  darwin = final: prev: {
    kitty = inputs.nixpkgs-stable.legacyPackages.${prev.system}.kitty;
    yabai = prev.yabai.overrideAttrs (oldAttrs: rec {
      version = "7.1.16";
      src = final.fetchzip {
        url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
        hash = "sha256-rEO+qcat6heF3qrypJ02Ivd2n0cEmiC/cNUN53oia4w=";
      };
    });
  };

  applications = final: prev: {
    iamb = inputs.iamb.packages.${prev.system}.default;
  };

  # --- Themes and assets ---
  themes = final: prev: {
    catppuccinThemes = import ./themes/catppuccin.nix {pkgs = final.pkgs;};
    nix-index-database = final.runCommandLocal "nix-index-database" {} ''
      mkdir -p $out
      ln -s ${inputs.nix-index-database.legacyPackages.${prev.system}.database} $out/files
    '';
  };
in
  [
    # Local overlays
    shell-scripts
    terminal
    system-libs
    networking
    media
    darwin
    themes
    applications

    # External input overlays
    inputs.deploy-rs.overlays.default
    inputs.eilmeldung.overlays.default
    inputs.handoff.overlays.default
    inputs.headplane.overlays.default
    inputs.nix-minecraft.overlay
    inputs.nur.overlays.default
    inputs.vicinae.overlays.default
  ]
  ++ (import ./neovim/overlays.nix {inherit inputs;})
