#!/bin/zsh

# Install instructions are fairly simple:
# > bash install.sh # Should install everything. You will need to grant some permissions as different things boot up.

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

## Formulae
echo "Installing Brew Formulae..."
### Essentials
brew install wget
brew install node
brew install gh
brew install ifstat
brew install lua
brew install --cask nikitabobko/tap/aerospace

### Terminal
brew install neovim
brew install zsh-autosuggestions
brew install zsh-fast-syntax-highlighting

### Nice to have
brew install chruby
brew install ruby-install
brew install btop


## Casks
echo "Installing Brew Casks..."
brew install --cask alacritty
brew install --cask spotify

# macOS Settings
# echo "Changing macOS defaults..."
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock "mru-spaces" -bool "false"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# See https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control.
# Prevents windows from showing up too small in mission control.
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock expose-group-apps -bool true
killall Dock
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Additional settings...
# defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.spaces spans-displays -bool false
# defaults write com.apple.LaunchServices LSQuarantine -bool false
# defaults write NSGlobalDomain KeyRepeat -int 1
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# defaults write NSGlobalDomain _HIHideMenuBar -bool true
# defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431"
# defaults write NSGlobalDomain AppleAccentColor -int 1
defaults write com.apple.screencapture location -string "$HOME/Desktop"
# defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"
# defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
# defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
# defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
# defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# defaults write com.apple.finder ShowStatusBar -bool false
# defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
# defaults write com.apple.Safari IncludeDevelopMenu -bool true
# defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
# defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
# defaults write -g NSWindowShouldDragOnGesture YES

# Copying and checking out configuration files
echo "Planting Configuration Files..."
[ ! -d "$HOME/dotfiles" ] && git clone --bare https://github.com/Alescontrela/dotfiles.git $HOME/dotfiles
git --git-dir=$HOME/dotfiles/ --work-tree=$HOME checkout master

# Install nvim plugged tool.
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Set ZSH as default terminal.
# 1. Determine the path to zsh
ZSH_PATH=$(which zsh)
# 2. Check if zsh is already the default to avoid unnecessary prompts
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    echo "Changing default shell to zsh..."
    
    # macOS-specific check for shell changes
    if [[ "$(uname)" == "Darwin" ]]; then
        chsh -s "$ZSH_PATH"
    else
        # Standard Linux chsh
        chsh -s "$ZSH_PATH"
    fi
else
    echo "zsh is already your default shell."
fi

echo "Installation complete...\n"

