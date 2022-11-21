if status is-interactive
    # Commands to run in interactive sessions can go here
end

export BROWSER="open"
export DYLD_FALLBACK_LIBRARY_PATH="/Library/Developer/CommandLineTools/usr/lib"
# export DYLD_FALLBACK_LIBRARY_PATH="/Library/Developer/CommandLineTools/usr/lib"
# export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export CARGO_TARGET_DIR="$HOME/.local/share/cargo-target"

