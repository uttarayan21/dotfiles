function man
    set oldIFS "$IFS"
    set IFS ""
    set page (/usr/bin/man "$argv" | col -b)
    if ! [ -z "$page" ]
        echo "$page" | nvim -R -c 'set ft=man nomod nolist' -
    end

    set IFS "$oldIFS"
end
