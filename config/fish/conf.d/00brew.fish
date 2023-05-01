if [ (uname) = "Darwin" ]
    set arch (arch)
    if [ "$arch" = "i386" ]
        # eval /usr/local/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
        /usr/local/bin/brew shellenv | source
        export PATH="/usr/local/opt/llvm/bin:$PATH"
    else
        # eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
        /opt/homebrew/bin/brew shellenv | source
        export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
    end

    export XDG_CONFIG_HOME="/Users/fs0c131y/.config"
end
