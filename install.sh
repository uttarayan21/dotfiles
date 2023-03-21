#!/bin/sh

# ensure_installed:
DOTFILES_REPO="https://github.com/uttarayan21/dotfiles"
INSTALLED="$HOME/.local/share/dotfiles"
git clone --recursive "$DOTFILES_REPO" "$INSTALLED"

for file in $(ls -1 $INSTALLED/config); do
    # echo "$INSTALLED/config/$(basename file)" $HOME/config/$(basename $file)
    ln -s "$INSTALLED/config/$(basename $file)" "$HOME/.config/$(basename $file)"
done
