# Good tutorials
# https://thevaluable.dev/zsh-install-configure-mouseless/
# https://thevaluable.dev/zsh-completion-guide-examples/
# https://github.com/Phantas0s/.dotfiles/blob/master/zsh/completion.zsh

# Set up prompt
PROMPT='%n@%m@[%1~]$'

setopt histignorealldups sharehistory

# Enable field splitting to be performed on unquoted parameter expansions.
# Similar to bash shell
# https://stackoverflow.com/a/6715447

# Use emacs keybindings even if our Editor is set to vim
bindkey -e

# Bash-like navigation
autoload -U select-word-style
select-word-style bash
# https://unix.stackexchange.com/a/726014
WORDCHARS=${WORDCHARS/\/}
WORDCHARS=${WORDCHARS/_}
WORDCHARS=${WORDCHARS/=}

# equivalent for .inputrc config
# Cycle through history based on characters already typed on the line
# https://unix.stackexchange.com/a/285151
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "\C-p" up-line-or-beginning-search
bindkey "\C-n" down-line-or-beginning-search

# Allow long history files
HISTSIZE=99999999
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'

# Define completers
zstyle ':completion:*' completer _extensions _complete _correct _approximate

# Formats
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{cyan}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

# Allow you to select in a menu
zstyle ':completion:*' menu select

# See ZSHCOMPWID "completion matching control"
# Case insensitive matcher
# https://superuser.com/a/1092328
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colors for files and directory
# There's no dircolors on MacOS? 
# https://unix.stackexchange.com/a/91978
# eval "$(dircolors -b)"
LS_COLORS='di=36;1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
if whence dircolors >/dev/null; then
  export LS_COLORS
  alias ls='ls --color'
else
  export CLICOLOR=1
  export LSCOLORS=GxFxCxDxBxegedabagaced
fi

# Automatic ls after cd
# https://stackoverflow.com/a/3964198
function chpwd() {
    emulate -L zsh
    ls 
}

# Load common alias
if [ -f ~/.common_alias ]; then
	source ~/.common_alias
fi

# Tmux configs
# For tmux session to get color.
export TERM=xterm-256color
# Tmux completion.
alias tma='tmux attach -t'
