# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


####################################################################################################
# Custom 
####################################################################################################

####################################################################################################
# Environment variables

# Created by `pipx` on 2024-07-23 08:47:15
export PATH="$PATH:/home/jiten-patel/.local/bin"

# JAVA Environment
export JAVA_HOME="/lib/jvm/java-21-openjdk-amd64"
export PATH="$PATH:$JAVA_HOME/bin"

# Maven
export M2_HOME="/usr/local/apache-maven/apache-maven-3.9.8"
export M2="$M2_HOME/bin"
export MAVEN_OPTS="-Xms256m -Xmx512m"
export PATH="$PATH:$M2"

# Antlr4
export CLASSPATH=".:/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH"
# simplify the use of the tool to generate lexer and parser
alias antlr4='java -Xmx500M -cp "/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH" org.antlr.v4.Tool'
# simplify the use of the tool to test the generated code
alias grun='java -Xmx500M -cp "/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH" org.antlr.v4.gui.TestRig'

# JDepend
export JDEPEND_HOME="/usr/local/jdepend-2.10"
export CLASSPATH="$CLASSPATH:$JDEPEND_HOME/lib/jdepend-<version>.jar"

# Neovim Default Editor
export EDITOR=nvim
export VISUAL=nvim
####################################################################################################
# Aliases

# check headset battery
alias chb='sudo headsetcontrol -b'

# edit keyd and reload
alias kd='sudoedit /etc/keyd/default.conf && sudo keyd reload'

# ls with color mode
alias ls='ls -G'

# ll to ls -lart
alias ll='ls -larth'

# clear terminal window
alias cc='clear'

# Create parent directories on demand
alias mkdir='mkdir -pv'

# xclip-copy
alias c='xclip -sel clip'

# copy current direct
alias ccd='pwd | xclip -sel clip'

# redirect output to /dev/null
alias idea-here='idea . > /dev/null 2>&1 &'

# memHogsTop, memHogsPs:  Find memory hogs
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

# topForever:  Continual 'top' listing (every 10 seconds)
alias topForever='top -l 9999999 -s 10 -o cpu'

# pip address
alias myip='curl ipinfo.io/ip'

# safe delete
alias rm='rm -i'
alias tp='trash-put'
alias tl='trash-list'
alias tr='trash-restore'
alias te='trash-empty'

alias pgadmin4="/usr/pgadmin4/bin/pgadmin4"

# uv aliases
alias uvr='uv run'
alias uva='uv add'
alias uvrm='uv remove'
alias uvs='uv sync'
alias uvl='uv lock'
alias uvt='uv tree'
alias uvpy='uv python'
alias uvv='uv venv'

# Development shortcuts
alias uvtest='uv run pytest'
alias uvfmt='uv format'

####################################################################################################
# PS1
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] > "

####################################################################################################
# load rvm (ruby version manager) if installed
[ -s /etc/profile.d/rvm.sh ] && source /etc/profile.d/rvm.sh

####################################################################################################
# haskell 
[ -f "/home/jiten-patel/.ghcup/env" ] && . "/home/jiten-patel/.ghcup/env" # ghcup-env

####################################################################################################
# prolog
export SWIVM_DIR="/home/jiten-patel/.swivm"
[ -s "$SWIVM_DIR/swivm.sh" ] && . "$SWIVM_DIR/swivm.sh"  # This loads swivm

####################################################################################################
# terraform
complete -C /usr/bin/terraform terraform

####################################################################################################
# node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

####################################################################################################
# rust
export PATH="/home/jiten-patel/.cargo/bin:$PATH"

####################################################################################################

# neovim 
export PATH="/opt/nvim-linux-x86_64/bin:$PATH"

# git subrepo
source ~/apps/git-subrepo/.rc

# opencode
export PATH=/home/jitenpatel/.opencode/bin:$PATH

. "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/opt/odin:$PATH"
####################################################################################################
fixclock() {
    sudo chronyc makestep &&
    sudo hwclock --systohc --utc
}

. "$HOME/.cargo/env"
