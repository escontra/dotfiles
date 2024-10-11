#!/bin/zsh

# Install instructions are fairly simple:
# > bash install.sh # Should install everything. You will need to grant some permissions as different things boot up.
# Head to .config/skhd/skhdrc which contains some specific settings for setting up Space focus.

# Troubleshooting:
# In case you get an error like:
# > Error: Your Command Line Tools are too outdated.
#   Update them from Software Update in System Settings.
#   If that doesn't show you any updates, run:
#     sudo rm -rf /Library/Developer/CommandLineTools
#     sudo xcode-select --install
#   Alternatively, manually download them from:
#     https://developer.apple.com/download/all/.
#   You should download the Command Line Tools for Xcode 16.0.
# Follow the instructions in: https://stackoverflow.com/questions/42538171/how-to-update-xcode-command-line-tools
# Basically:
# softwareupdate --list
# softwareupdate -i "Command Line Tools for Xcode-16.0"
# Or whatever the correct version is 

# Disabling SIP is required for MacOS Sequoia :( https://github.com/koekeishiya/yabai/issues/2324


corp=false
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --corp) corp=true ;;    # Set to true if the flag --corp is used
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done
if [[ "$corp" == "true" ]]; then
    echo "Installing corp config"
else
    echo "Installing non corp config"
fi

# Install xCode cli tools
echo "Installing commandline tools..."
# [ -d "/Library/Developer/CommandLineTools" ] && sudo rm -rf "/Library/Developer/CommandLineTools"
xcode-select --install

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH=/opt/homebrew/bin:$PATH
echo >> "$HOME/.zprofile"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew analytics off

## Taps
echo "Tapping Brew..."
# brew tap homebrew/cask-fonts
brew tap FelixKratz/formulae
brew tap koekeishiya/formulae

## Formulae
echo "Installing Brew Formulae..."
### Essentials
# brew install gsl
# brew install llvm
# brew install boost
# brew install libomp
# brew install armadillo
brew install wget
brew install node
# brew install jq
# brew install ripgrep
# brew install bear
# brew install mas
brew install gh
brew install ifstat
brew install switchaudio-osx
brew install skhd
brew install sketchybar
brew install lua
brew install nowplaying-cli
if [[ "$corp" == "false" ]]; then
  brew install borders
fi
brew install yabai

### Terminal
brew install neovim
# brew install helix
# brew install starship
brew install zsh-autosuggestions
brew install zsh-fast-syntax-highlighting
# brew install zoxide

### Nice to have
brew install chruby
brew install ruby-install
# brew install lulu
brew install btop
# brew install lazygit
# brew install wireguard-go
# brew install dooit

### Custom HEAD only forks
# brew install fnnn --head # nnn fork (changed colors, keymappings)

## Casks
echo "Installing Brew Casks..."
### Terminals & Browsers
brew install --cask alacritty
# brew install --cask kitty
# brew install --cask orion
brew install --cask spotify

### Fonts
brew install --cask sf-symbols
# brew install --cask homebrew/cask-fonts/font-sf-mono
# brew install --cask homebrew/cask-fonts/font-sf-pro
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono
brew install --cask font-fira-code

# Install rust and cargo.
# curl https://sh.rustup.rs -sSf | sh

# Mac App Store Apps
# echo "Installing Mac App Store Apps..."
# mas install 1451685025 #Wireguard
# mas install 497799835 #xCode
# mas install 1480933944 #Vimari

# macOS Settings
# echo "Changing macOS defaults..."
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock "mru-spaces" -bool "false"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Additional settings...
# defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# defaults write com.apple.spaces spans-displays -bool false
# defaults write com.apple.LaunchServices LSQuarantine -bool false
# defaults write NSGlobalDomain KeyRepeat -int 1
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# defaults write NSGlobalDomain _HIHideMenuBar -bool true
# defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431"
# defaults write NSGlobalDomain AppleAccentColor -int 1
# defaults write com.apple.screencapture location -string "$HOME/Desktop"
# defaults write com.apple.screencapture disable-shadow -bool true
# defaults write com.apple.screencapture type -string "png"
# defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
# defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
# defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
# defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
# defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# defaults write com.apple.finder ShowStatusBar -bool false
# defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
# defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
# defaults write com.apple.Safari IncludeDevelopMenu -bool true
# defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
# defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
# defaults write -g NSWindowShouldDragOnGesture YES

## Fix for MX Master 3S
# sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid

# Copying and checking out configuration files
echo "Planting Configuration Files..."
# [ ! -d "$HOME/dotfiles" ] && git clone --bare https://github.com/Alescontrela/dotfiles.git $HOME/dotfiles
# [ ! -d "$HOME/dotfiles" ] && git clone --branch master https://github.com/Alescontrela/dotfiles.git $HOME/dotfiles
# git --git-dir=$HOME/dotfiles/ --work-tree=$HOME checkout master
[ ! -d "$HOME/dotfiles" ] && git clone --bare https://github.com/Alescontrela/dotfiles.git $HOME/dotfiles
git --git-dir=$HOME/dotfiles/ --work-tree=$HOME checkout master

# Installing Fonts
echo "Installing fonts..."
git clone https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git /tmp/SFMono_Nerd_Font
mv /tmp/SFMono_Nerd_Font/* $HOME/Library/Fonts
rm -rf /tmp/SFMono_Nerd_Font/
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# Symlink zshrc and yabairc.
# echo "Planting Zsh config..."
# [ -f "$HOME/.zshrc_backup" ] && rm -rf $HOME/.zshrc_backup
# [ -f "$HOME/.zshrc" ] && mv $HOME/.zshrc $HOME/.zshrc_backup
# ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc

# Make config directory.
# export XDG_CONFIG_HOME="$HOME/.config"
# [ ! -d "$XDG_CONFIG_HOME" ] && mkdir -p $XDG_CONFIG_HOME

# Install nvim plugged tool.
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


# Configs!
# sketchybar config.
echo "Installing Sketchybar and planting config..."
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
[ -d "$XDG_CONFIG_HOME/sketchybar_backup" ] && rm -rf $XDG_CONFIG_HOME/sketchybar_backup
[ -d "$XDG_CONFIG_HOME/sketchybar" ] && mv $XDG_CONFIG_HOME/sketchybar $XDG_CONFIG_HOME/sketchybar_backup
cp -r $HOME/dotfiles/.config/sketchybar $XDG_CONFIG_HOME/sketchybar

# yabai config.
# echo "Planting Yabai config..."
# [ -d "$XDG_CONFIG_HOME/yabai_backup" ] && rm -rf $XDG_CONFIG_HOME/yabai_backup
# [ -d "$XDG_CONFIG_HOME/yabai" ] && mv $XDG_CONFIG_HOME/yabai $XDG_CONFIG_HOME/yabai_backup
# cp -r $HOME/dotfiles/.config/yabai $XDG_CONFIG_HOME/yabai

# skhd config.
# echo "Planting skhd config..."
# [ -d "$XDG_CONFIG_HOME/skhd_backup" ] && rm -rf $XDG_CONFIG_HOME/skhd_backup
# [ -d "$XDG_CONFIG_HOME/skhd" ] && mv $XDG_CONFIG_HOME/skhd $XDG_CONFIG_HOME/skhd_backup
# cp -r $HOME/dotfiles/.config/skhd $XDG_CONFIG_HOME/skhd

# Starship config.
# [ -d "$XDG_CONFIG_HOME/starship_backup.toml" ] && rm -rf $XDG_CONFIG_HOME/starship_backup.toml
# [ -d "$XDG_CONFIG_HOME/starship.toml" ] && mv $XDG_CONFIG_HOME/starship.toml $XDG_CONFIG_HOME/starship_backup.toml
# cp -r $HOME/dotfiles/.config/starship.toml $XDG_CONFIG_HOME/starship.toml

# alacritty config.
# echo "Planting alacritty config..."
# [ -d "$XDG_CONFIG_HOME/alacritty_backup" ] && rm -rf $XDG_CONFIG_HOME/alacritty_backup
# [ -d "$XDG_CONFIG_HOME/alacritty" ] && mv $XDG_CONFIG_HOME/alacritty $XDG_CONFIG_HOME/alacritty_backup
# cp -r $HOME/dotfiles/.config/alacritty $XDG_CONFIG_HOME/alacritty

# borders config.
# echo "Planting borders config..."
# [ -d "$XDG_CONFIG_HOME/borders_backup" ] && rm -rf $XDG_CONFIG_HOME/borders_backup
# [ -d "$XDG_CONFIG_HOME/borders" ] && mv $XDG_CONFIG_HOME/borders $XDG_CONFIG_HOME/borders_backup
# cp -r $HOME/dotfiles/.config/borders $XDG_CONFIG_HOME/borders

# neovim config.
# echo "Planting neovim config..."
# [ -d "$XDG_CONFIG_HOME/nvim_backup" ] && rm -rf $XDG_CONFIG_HOME/nvim_backup
# [ -d "$XDG_CONFIG_HOME/nvim" ] && mv $XDG_CONFIG_HOME/nvim $XDG_CONFIG_HOME/nvim_backup
# cp -r $HOME/dotfiles/.config/nvim $XDG_CONFIG_HOME/nvim

# export SHELL=$(which zsh)
# exec $SHELL -l
source $HOME/.zshrc
# cfg config --local status.showUntrackedFiles no

# Python Packages (mainly for data science)
# echo "Installing Python Packages..."
# curl https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh | sh
# source $HOME/.zshrc
# conda install -c apple tensorflow-deps
# conda install -c conda-forge pybind11
# conda install matplotlib
# conda install jupyterlab
# conda install seaborn
# conda install opencv
# conda install joblib
# conda install pytables
# pip install tensorflow-macos
# pip install tensorflow-metal
# pip install debugpy
# pip install sklearn



# Start Services
echo "Starting Services (grant permissions)..."
skhd --start-service
yabai --start-service
brew services start sketchybar
if [[ "$corp" == "false" ]]; then
  brew services start borders
fi
# brew services start svim

csrutil status
echo "(optional) Disable SIP for advanced yabai features."
echo "(optional) Add sudoer manually:\n '$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa' to '/private/etc/sudoers.d/yabai'"

echo "Installation complete...\n"

