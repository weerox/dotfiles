# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -la --color=auto'

# https://news.ycombinator.com/item?id=11071754
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Instead of aliasing open we will create a function
#alias open='xdg-open'
# The ampersand runs the command in a new process
# and the parentheses makes it run in a subshell,
# effectively silencing it.
open() {
	(xdg-open "$*" &)
}

ps1_git() {
	git rev-parse --is-inside-work-tree 2>/dev/null 1>&2
	if [[ $? -eq 0 ]]; then
		PS1_GIT_BRANCH=$(git branch --show-current)
		PS1_GIT="$PS1_GIT_BRANCH "
	else
		PS1_GIT=''
	fi
	echo "$PS1_GIT"
}

PS1='$(ps1_git)\W \$ '
