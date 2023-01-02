#!/bin/sh

# ensure_installed:
DOTFILES_REPO="https://github.com/uttarayan21/dotfiles"
INSTALLED="$HOME/.local/share/dotfiles"
git clone "$DOTFILES_REPO" "$INSTALLED"

for file in "$INSTALLED"; do
    ln -s "$file" $HOME/config/$(basename $file)
done
