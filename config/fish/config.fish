function man
    set oldIFS "$IFS"
    set IFS ""
    set page (/usr/bin/man $argv | col -b)
    if ! [ -z "$page" ]
        echo "$page" | nvim -R -c 'set ft=man nomod nolist' -
    end

    set IFS "$oldIFS"
end


function __fish_command_not_found_handler --on-event fish_command_not_found
    echo "fish: Unknown command '$argv'"
end

thefuck --alias | source
