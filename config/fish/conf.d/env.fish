# GTK
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc

# Notmuch
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME"/notmuch/notmuchrc
export NMBGIT="$XDG_DATA_HOME"/notmuch/nmbug

# Less
export LESSKEY="$XDG_CONFIG_HOME"/less/lesskey
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# Android
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME"/android
export ADB_VENDOR_KEY="$XDG_CONFIG_HOME"/android
export ANDROID_PREFS_ROOT="$XDG_CONFIG_HOME"/android
export ADB_KEYS_PATH="$ANDROID_PREFS_ROOT"
export ANDROID_EMULATOR_HOME="$XDG_DATA_HOME"/android/emulator

# Node
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export npm_config_prefix=$XDG_DATA_HOME/node_modules

# Wine
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default

# Java
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

# Python
export PYLINTHOME="$XDG_CACHE_HOME"/pylint
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/startup.py

# export XAUTHORITY="$XDG_RUNTIME_DIR"/xauthority
export gnome_user_dir="$XDG_CONFIG_HOME"/gnome/apps

# LaTeX
export TEXMFHOME=$XDG_DATA_HOME/texmf
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config

# Ruby gems
export GEM_HOME="$XDG_DATA_HOME"/gem
export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle

# LANG
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# sxhkd
export SXHKD_SHELL="/bin/sh"

# fzf
export FZF_DEFAULT_COMMAND='fd --type f'

# Pass
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass

# EDITOR
export EDITOR=nvim
export VISUAL=nvim

# GPG
export GPG_TTY=(tty)
