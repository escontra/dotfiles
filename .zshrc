# Set up the prompt
autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# --- Vi Keybindings & Clipboard Commands ---

# Enable Vi mode and set a fast escape key timeout
bindkey -v
export KEYTIMEOUT=1

# Custom function to yank (copy) to system clipboard using xclip
x-yank() {
    zle copy-region-as-kill
    print -rn -- $CUTBUFFER | xclip -sel clipboard
}
zle -N x-yank

# Custom function to cut to system clipboard using xclip
x-cut() {
    zle kill-region
    print -rn -- $CUTBUFFER | xclip -sel clipboard
}
zle -N x-cut

# Custom function to paste from system clipboard
x-paste() {
    PASTE=$(xclip -o -sel clipboard)
    LBUFFER="$LBUFFER${RBUFFER:0:1}"
    RBUFFER="$PASTE${RBUFFER:1:${#RBUFFER}}"
}
zle -N x-paste

# Map clipboard and navigation functions in Command Mode
bindkey -M vicmd "y" x-yank
bindkey -M vicmd "Y" x-cut
bindkey -M vicmd "p" x-paste
bindkey -M vicmd "^K" up-history
bindkey -M vicmd "^J" down-history

# Enable 'v' in Command Mode to edit the current command line in a full Vim buffer
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Start the line editor in command mode by default
zle-line-init() { zle vi-cmd-mode; }
zle -N zle-line-init

# --- End Vi Section ---

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
