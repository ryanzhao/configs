#*********************************************
# put some system dependent test to determine
# what kind of aliases I should use
#*********************************************
OS_TYPE=`uname -s`
#*********************************************
# Settings for Mac OS only
#*********************************************
if [ $OS_TYPE == "Darwin" ]; then
    #---------------------------------------
    # To surpress the error
    # "bash: warning: setlocale: LC_CTYPE: 
    # cannot change locale (UTF-8)"
    #---------------------------------------
    export LC_CTYPE="en_US.UTF-8"
    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    export EDITOR=/usr/bin/vim
    #------------------------------------
    # bash-completion (on my Mac laptop)
    #------------------------------------
		if [ -f "/usr/local/etc/profile.d/bash_completion.sh" ]; then
			source "/usr/local/etc/profile.d/bash_completion.sh"
		fi
    #---------------------------------------
    # A whole bunch of aliases useful to me
    #---------------------------------------
    #-------------------
    # Always cd then ls
    #-------------------
    cd() {
        builtin cd "$*" && ls 
    }
    
    #-----------------------------------------------------------------------------
    # mac os is stupid to write its own ls, so when you use a pager like "more", 
    # you won't have color displaying, e.g. for folders.
    #-----------------------------------------------------------------------------
    alias ls='ls -G'
    alias lll='ls -lG| more'
    alias ll='ls -lG'
    alias la='ls -alG'
    
    #*********************************************
    # Settings for linux only
    #*********************************************
elif [ $OS_TYPE == "Linux" ]; then
    #---------------------------
    # Source global definitions
    #---------------------------
    if [ -f /etc/bashrc ]; then
        . /etc/bashrc
    fi
    #------------------------------------------------------------------------
    # set the umask, which controls the permissions on new files you create.
    #   022 denies write access to other people, but not read access.
    #   077 denies read and write access to other people.
    #------------------------------------------------------------------------
    # umask 077
    #---------
    # Aliases
    #---------
    alias ll="ls -l"
    alias la='ls -al |more'
    alias ls='ls --color'
    alias lll='ls -l |more'
    #-----------------------------
    # Replace every cd with cd+ls
    # Copied from somewhere
    #-----------------------------
    if [[ $- == *i* ]]; then  # if running interactively
        cd() {
            builtin cd "$@" && ls --color
        }
    fi
    export PATH="$HOME/Library/bin:/opt/intel/bin:${PATH}"
    export LS_COLORS='di=36;1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
    #---------------------
    # unidentified system
    #---------------------
else
    echo "system unidentified"
fi

if [ -f ~/.common_alias ]; then
	source ~/.common_alias
fi
#-------------------------------
#This one is for git completion
#-------------------------------
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
fi
#------------------------
# for prompt of terminal
#------------------------
export PS1="\u@\h@[\W]\$"
#----------------
# editor setting
#----------------
export EDITOR=vim
export TMPDIR='/tmp'

# For tmux session to get color.
export TERM=xterm-256color
# Tmux completion.
_tma() {
    TMUX_SESSIONS=$(tmux ls | awk '{print $1}' | sed 's/://g' |xargs)
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$TMUX_SESSIONS" -- $cur) )
}
complete -F _tma tma
alias tma='tmux attach -t $1'


# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
#
# To support bash hisotry when used insided tmux.
# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups
# append history entries
shopt -s histappend
# After each command, save and reload history
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
