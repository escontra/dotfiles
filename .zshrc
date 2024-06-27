# Download Znap, if it's not there yet.
# [[ -r ~/Repos/znap/znap.zsh ]] ||
#     git clone --depth 1 -- \
#         https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
# source ~/Repos/znap/znap.zsh  # Start Znap

export PATH=/opt/homebrew/bin:$PATH

# Source zsh plugins
source $(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Vi commands
bindkey -v
export KEYTIMEOUT=1

x-yank() {
    zle copy-region-as-kill
    print -rn -- $CUTBUFFER | xclip -sel clipboard
}
zle -N x-yank

x-cut() {
    zle kill-region
    print -rn -- $CUTBUFFER | xclip -sel clipboard
}
zle -N x-cut

x-paste() {
    PASTE=$(xclip -o -sel clipboard)
    LBUFFER="$LBUFFER${RBUFFER:0:1}"
    RBUFFER="$PASTE${RBUFFER:1:${#RBUFFER}}"
}
zle -N x-paste

bindkey -M vicmd "y" x-yank
bindkey -M vicmd "Y" x-cut
bindkey -M vicmd "p" x-paste
bindkey -M vicmd "^K" up-history
bindkey -M vicmd "^J" down-history

autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Start line editor in command mode.
zle-line-init() { zle vi-cmd-mode; }
zle -N zle-line-init

# Aliases for common dirs
alias home="cd ~"

# System Aliases
alias ..="cd .."
alias x="exit"

# Git Aliases
alias add="git add"
alias commit="git commit"
alias pull="git pull"
alias stat="git status"
alias gdiff="git diff HEAD"
alias vdiff="git difftool HEAD"
alias log="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias cfg="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias push="git push"
alias g="lazygit"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

alias ssh="TERM=xterm-256color ssh"

alias n="nnn"
function nnn () {
  command nnn "$@"

  if [ -f "$NNN_TMPFILE" ]; then
          . "$NNN_TMPFILE"
  fi
}

function kill () {
  command kill -KILL $(pidof "$@")
}

function suyabai () {
  SHA256=$(shasum -a 256 /opt/homebrew/bin/yabai | awk "{print \$1;}")
  if [ -f "/private/etc/sudoers.d/yabai" ]; then
    sudo sed -i '' -e 's/sha256:[[:alnum:]]*/sha256:'${SHA256}'/' /private/etc/sudoers.d/yabai
  else
    echo "sudoers file does not exist yet"
  fi
}

# Color Scheme
export BLACK=0xff181819
export WHITE=0xffe2e2e3
export RED=0xfffc5d7c
export GREEN=0xff9ed072
export BLUE=0xff76cce0
export YELLOW=0xffe7c664
export ORANGE=0xfff39660
export MAGENTA=0xffb39df3
export GREY=0xff7f8490
export TRANSPARENT=0x00000000
export BG0=0xff2c2e34
export BG1=0xff363944
export BG2=0xff414550

source "$HOME/.cargo/env"


# Only load conda into path but dont actually use the bloat that comes with it
# export PATH="$HOME/miniforge3/bin:/usr/local/anaconda3/bin:$PATH:$(brew --prefix)/opt/llvm/bin"
export NNN_TMPFILE="$HOME/.config/nnn/.lastd"
export NNN_OPTS="AdHoU"
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
export EDITOR="$(which hx)"
export VISUAL="$(which hx)"
export MANPAGER="$(which nvim) +Man!"
export XDG_CONFIG_HOME="$HOME/.config"

# zsh-autosuggestions.
bindkey '^ ' autosuggest-accept


