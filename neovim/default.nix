{pkgs, ...}: let
  options = import ./options.nix;
  keys = import ./keymaps.nix {inherit pkgs;};
  extra = import ./extra.nix {inherit pkgs;};
  plugins =
    (import ./plugins/git.nix)
    // (import ./plugins/ui.nix)
    // (import ./plugins/formatting.nix)
    // (import ./plugins/completion.nix)
    // (import ./plugins/lsp.nix {inherit pkgs;})
    // (import ./plugins/rust.nix {inherit pkgs;})
    // (import ./plugins/treesitter.nix)
    // (import ./plugins/telescope.nix)
    // (import ./plugins/dap.nix)
    // (import ./plugins/misc.nix);
in
  options
  // keys
  // extra
  // {
    inherit plugins;
  }
