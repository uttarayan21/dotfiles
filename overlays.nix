{inputs, ...}: let
  args = {inherit inputs;};
in
  [
    # Local overlays
    (import ./overlays/shell-scripts.nix args)
    (import ./overlays/terminal.nix args)
    (import ./overlays/system-libs.nix args)
    (import ./overlays/networking.nix args)
    (import ./overlays/media.nix args)
    (import ./overlays/darwin.nix args)
    (import ./overlays/themes.nix args)
    (import ./overlays/gaming.nix args)
    (import ./overlays/applications.nix args)
    (import ./overlays/flat-manager.nix args)
    # (import ./overlays/ai.nix args)

    # External input overlays
    inputs.deploy-rs.overlays.default
    inputs.eilmeldung.overlays.default
    inputs.handoff.overlays.default
    # inputs.headplane.overlays.default
    inputs.nix-minecraft.overlay
    inputs.nur.overlays.default
    inputs.vicinae.overlays.default
    inputs.hyprland.overlays.hyprland-packages
    inputs.hyprland.overlays.hyprland-extras
  ]
  ++ (import ./neovim/overlays.nix {inherit inputs;})
