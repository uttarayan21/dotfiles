abbr t '$HOME/.config/tmux/start-tmux'

if uname | grep -q Darwin
    abbr find   gfind
    abbr sed    gsed
end

if type -q nvim
    abbr vim    nvim
    abbr v      nvim
end
if type -q bat
    abbr cat    bat
end
if type -q exa
    abbr ls     exa
    abbr ll     exa -l
    abbr la     exa -la
end
if type -q zoxide
    abbr cd     z
end
if type -q git
    abbr g      git
    abbr gp     git push
    abbr gpu    git pull
end
if type -q evcxr
    abbr reru   evcxr
end
if not type -q wget
    abbr wget   curl -O
end
