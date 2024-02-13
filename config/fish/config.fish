if status is-interactive
    macchina
end

export DYLD_FALLBACK_LIBRARY_PATH="/Library/Developer/CommandLineTools/usr/lib"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export CARGO_TARGET_DIR="$HOME/.local/share/cargo-target"

# fish_vi_key_bindings
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/fs0c131y/Projects/gcloud/google-cloud-sdk/path.fish.inc' ]; . '/Users/fs0c131y/Projects/gcloud/google-cloud-sdk/path.fish.inc'; end

alias rebuds="bluetoothctl remove XX:XX:XX:XX:XX:XX; bluetoothctl scan on;bluetoothctl pair XX:XX:XX:XX:XX:XX; bluetoothctl connect XX:XX:XX:XX:XX:XX"
mkdir -p ~/.config/fish/completions
carapace --list | awk '{print $1}' | xargs -I{} touch ~/.config/fish/completions/{}.fish # disable auto-loaded completions (#185)
carapace _carapace | source
