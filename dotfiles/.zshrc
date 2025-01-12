export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

# export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
eval $(keychain --eval --quiet github_personal)


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export GCLOUD=$HOME/.local/share/google-cloud-sdk
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$HOME/bin:$HOME/.local/bin:$PATH:$GCLOUD/bin:$GOBIN
export DBEE=$XDG_DATA_HOME/nvim/dbee/bin
export QT_QPA_PLATFORMTHEME=qt6ct
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 30

COMPLETION_WAITING_DOTS="true"
ENABLE_CORRECTION="true"


plugins=(gitfast jsontools taskwarrior copybuffer dotenv jump virtualenvwrapper zsh-syntax-highlighting zsh-vim-mode)

source $ZSH/oh-my-zsh.sh

export WORKON_HOME=$HOME/.virtualenvs
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"
export MANPAGER='nvim +Man!'


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Not needed for now because jacob is a nopasswrd sudoer
# But I'm not sure if this is a good idea
# alias pacman="sudo pacman"

alias c="pygmentize -g"
# https://unix.stackexchange.com/questions/42757/make-rm-move-to-trash
alias tt="gio trash"
alias gs="git status"
alias j="jump"
alias nz="nvim ~/.zshrc"
alias np="nvim ~/.p10k.zsh"
alias nh="nvim ~/.config/hypr/hyprland.conf"
alias ff="grep -r . -ie"
alias fF="find . | grep -i"
alias f=grep
alias fz="grep -r ~/.zshrc -ie"
alias fp="grep -r ~/.p10k.zsh -ie"
alias fh="grep -r ~/.config/hypr/hyprland.conf -ie"
alias ls=eza --icons

function fif() {
  # find in file: finds a string in a file
  # basically the same as f, but i think the filename first is more inutitive
  grep -r $1 -i $2
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line enables shell command completion for gcloud.
if [ -f $GCLOUD'/completion.zsh.inc' ]; then . $GCLOUD'/completion.zsh.inc'; fi
