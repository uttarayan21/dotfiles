## Dotfiles

These are dotfiles for my Linux and MacOS machines

### Linux
- OS: NixOS
- Shell: fish / nushell
- Editor: nvim / neovide
- WM / DE: [hyprland](https://hyprland.org)
- Terminal: foot / wezterm

### MacOS 
- OS: MacOS Ventura
- Shell: fish / nushell
- Editor: nvim / neovide
- WM: [yabai](https://github.com/koekeishiya/yabai)
- Terminal: wezterm

### Neovim

If you want to try my neovim config just do
```
nix run github:uttarayan21/dotfiles#neovim
```

### Install nix
```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
### Install this
```
#either this for macos
nix run nix-darwin -- switch --flake .#name
#or this for nixos
nixos-rebuild switch --flake .#name
```




### For nix

I'm a recent convert to NixOS from ArchLinux and have been usin it as primary os as well as a package manager on macos so the flake.nix contains configuration for both nix-darwin as well as nixos. It also contains a native home-manager module configuration for non-nixos devices ( like a SteamDeck ).

#### Tools
Some useful tools I regularly use.
| Name          | Repo
| ---           | ---
| `bat`         | [sharkdp/bat](https://github.com/sharkdp/fd)
| `dust`        | [bootandy/dust](https://github.com/bootandy/dust)
| `exa`         | [ogham/exa](https://github.com/ogham/exa)
| `fd`          | [sharkdp/fd](https://github.com/sharkdp/fd)
| `fnm`         | [Schniz/fnm](https://github.com/Schniz/fnm)
| `fzf`         | [junegunn/fzf](https://github.com/junegunn/fzf)
| `glow`        | [charmbracelet/glow](https://github.com/charmbracelet/glow)
| `just`        | [casey/just](https://github.com/casey/just)
| `macchina`    | [macchina-cli/macchina](https://github.com/Macchina-CLI/macchina)
| `rg/ripgrep`  | [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)
| `starship`    | [starship/starship](https://github.com/starship/starship)
| `z/zoxide`    | [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide)
| `anyrun`      | [Kirottu/anyrun](https://github.com/Kirottu/anyrun)


#### Others
`zig` zig toolchain can be used to compile tree-sitter definitions without having to go through all the hassle of setting up llvm / MSVC on windows  
`hx/helix` Vim/Neovim - like editor which has autocomplete, tree-sitter, debugger built-in.  
`winget` Use winget to install tools onto windows. It comes by default and can easily install most things.  
