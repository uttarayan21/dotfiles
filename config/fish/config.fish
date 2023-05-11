if status is-interactive
    macchina
end

export BROWSER="open"
export DYLD_FALLBACK_LIBRARY_PATH="/Library/Developer/CommandLineTools/usr/lib"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export CARGO_TARGET_DIR="$HOME/.local/share/cargo-target"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/fs0c131y/Projects/gcloud/google-cloud-sdk/path.fish.inc' ]; . '/Users/fs0c131y/Projects/gcloud/google-cloud-sdk/path.fish.inc'; end

