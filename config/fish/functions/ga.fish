function ga --argument-names source target --description "Check how much ahead a git branch is from another"
    if test -z "$source"
        echo "Usage: ga source target"
        return 1
    end
    if test -z "$target"
        set target (git rev-parse --abbrev-ref HEAD)
    end
    echo "$source"\t"$target"
    git rev-list --left-right --count "$source"..."$target"
end


