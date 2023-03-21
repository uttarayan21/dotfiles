#!/bin/sh

## I mostly use archlinux so this will be for archlinux

pacman -S base-devel zoxide fd bat exa fish neovim unzip p7zip # will add more later

## Install paru
git clone https://aur.archlinux.org/paru ~/.cache/paru/clone/paru
pushd ~/.cache/paru/clone/paru
makepkg -si
popd

## Install plymouth
paru -S plymouth-git

## Install a plymouth theme
git clone https://github.com/uttarayan21/plymouth-theme-archmac
pushd plymouth-theme-archmac
makepkg -si
popd

## Install some few more things

