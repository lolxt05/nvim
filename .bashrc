
case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize

function parse_git_branch {
    git branch 2>/dev/null | grep '^*' | sed 's/^* //'
}

export PS1='\e[32m\]\u@\h \[\e[33m\]\w\[\e[36m\] $(parse_git_branch)\[\e[0m\]\n\$ '

alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gco='git checkout'
alias cls='clear'
alias ll='ls -al'
alias bashrc='nano /home/wstadmin/.bashrc && source /home/wstadmin/.bashrc'
alias gitfull='function _gitfull(){ git pull && git add . && git commit -m "$1" && git push; }; _gitfull'


cd ~/codebase

declare -i i=0
declare -a array

for d in */ ; do
    d="${d%/}"
    array[$i]="${d}"
    ((i++))
    eval "function ${d}() {
        cd /home/wstadmin/codebase/${d} || return
        source /home/wstadmin/codebase/${d}/${d}-venv/bin/activate
	clear
    }"
done
cd ~
shutdown() {
   ~/shutdown.sh
   command shutdown now
}

eval "$(~/.rbenv/bin/rbenv init - --no-rehash bash)"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
alias bat='batcat'

#/home/wstadmin/git_pull_all.sh
clear
export TERM=xterm-256color
. "$HOME/.cargo/env"
export PATH="$PATH:/opt/nvim"
