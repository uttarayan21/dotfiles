function cclose --argument-names issue target --description "Comment and close github issue"
    if test -z "$issue"
        echo "Usage: cclose {issue num}"
        return 1
    end
    gh issue comment "$issue"
    gh issue close "$issue"
end


