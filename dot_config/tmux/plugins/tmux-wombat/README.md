This is just the base wombat theme from tmuxline.vim and vim-airline/vim-airline

Will add a few features
TODO:
* ~Battery Stats (Halfway there) (Switched to tmux-battery)~
* Git Branch
* ~Highlight the session name while prefix is pressed~
* Weather/Temp (maybe)

NOPE:
* ~Mpc status/song name~ (Takes up too much space)


#*INSTALL*

Add `set -g @plugin 'uttarayan21/tmux-wombat'` to your tmux.conf and then press <prefix> + I if you use tpm else you can just run wombat.tmux from shell
Using tmux-battery for battery stats so use put this before tmux-battery in your tmux.conf
