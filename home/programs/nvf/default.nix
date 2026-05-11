# Migration notes (nixvim → nvf, 2026-05-11)
#
# Dropped intentionally (dangling / dead bindings in the old config):
#   - ChatGPT keymap <C-c> (plugin was never enabled)
#   - Devdocs keymaps <leader>hh / <leader>hl (plugin was never enabled)
#   - cmp-ctags blink source: its vim autoload requires nvim-cmp, which
#     isn't loaded under blink-cmp; produced startup errors
#   - blink-cmp-spell source: package shipped but not in the active source list
#   - treesitter `additional_vim_regex_highlighting = true` — no nvf knob
#   - telescope layout_config.vertical.size override — nvf rejected schema
#
# Treesitter grammars not carried over because they're absent from
# pkgs.vimPlugins.nvim-treesitter.grammarPlugins (nvf's required shape):
#   - norg, norg-meta  (neorg installs its own parser at runtime)
#   - d2, pest         (*.d2 and *.pest lose TS highlighting until wrapped)
# Kept (available in grammarPlugins): just, nu, slint
#
# Rustaceanvim tweaks not ported — nvf builds vim.g.rustaceanvim itself:
#   - tools.float_win_config.border = "rounded"
#   - tools.enable_clippy = false
#   - per-buffer on_attach overrides for <leader>a (RustLsp codeAction group)
#     and K (RustLsp hover actions) — global <leader>a now uses the plain
#     vim.lsp.buf.code_action; K falls back to default LSP hover
#
# Shape changes (functionally equivalent):
#   - opencode-nvim configured via vim.g.opencode_opts (no longer .setup())
#   - crates-nvim enabled via vim.languages.rust.extensions.crates-nvim
#     instead of being wired by hand under extraPlugins
#   - stylix.targets.nixvim → stylix.targets.nvf
#
# Cosmetic refs not updated (still point at nixvim search site):
#   - home/apps/firefox.nix       (firefox search engine)
#   - nixos/tako/services/glance.nix (glance bookmark)
{
  imports = [
    ./options.nix
    ./theme.nix
    ./keymaps.nix
    ./autocmds.nix
    ./lsp.nix
    ./completion.nix
    ./treesitter.nix
    ./telescope.nix
    ./git.nix
    ./formatting.nix
    ./rust.nix
    ./dap.nix
    ./ui.nix
    ./notes.nix
    ./misc.nix
    ./extra.nix
  ];
}
