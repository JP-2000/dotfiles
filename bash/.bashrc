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

# Neovim Default Editor
export EDITOR=nvim
export VISUAL=nvim
####################################################################################################
# Aliases

# check headset battery
alias chb='sudo headsetcontrol -b'

# edit keyd and reload
alias kd='sudoedit /etc/keyd/default.conf && sudo keyd reload'

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
if [ -r /etc/profile.d/rvm.sh ]; then
    source /etc/profile.d/rvm.sh
fi

####################################################################################################
# haskell 
if [ -r "$HOME/.ghcup/env" ]; then
    . "$HOME/.ghcup/env"
fi

####################################################################################################
# prolog
export SWIVM_DIR="$HOME/.swivm"
if [ -r "$SWIVM_DIR/swivm.sh" ]; then
    . "$SWIVM_DIR/swivm.sh"
fi

####################################################################################################
# terraform
if command -v terraform > /dev/null 2>&1; then
    complete -C "$(command -v terraform)" terraform
fi

####################################################################################################
# node
export NVM_DIR="$HOME/.nvm"
if [ -r "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
fi
if [ -r "$NVM_DIR/bash_completion" ]; then
    . "$NVM_DIR/bash_completion"
fi

####################################################################################################
# git subrepo
if [ -r "$HOME/apps/git-subrepo/.rc" ]; then
    source "$HOME/apps/git-subrepo/.rc"
fi

# opencode
if [ -d "$HOME/.opencode/bin" ]; then
    case ":$PATH:" in
        *:"$HOME/.opencode/bin":*)
            ;;
        *)
            export PATH="$HOME/.opencode/bin:$PATH"
            ;;
    esac
fi

# Local tools and Rust
if [ -r "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
fi
if [ -r "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# Odin
if [ -d /opt/odin ]; then
    case ":$PATH:" in
        *:/opt/odin:*)
            ;;
        *)
            export PATH="/opt/odin:$PATH"
            ;;
    esac
fi

####################################################################################################
fixclock() {
    sudo chronyc makestep &&
    sudo hwclock --systohc --utc
}
