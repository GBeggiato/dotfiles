# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h] \w\n\$ '

HISTCONTROL=ignoreboth
shopt -s histappend # append to the history file, don't overwrite it
HISTSIZE=100
HISTFILESIZE=200

alias la='ls --color=auto -ahl'
alias grep='grep --color=auto'

alias update='sudo xbps-install -Suv'
alias cleanup='sudo xbps-remove --remove-orphans -Rv'
