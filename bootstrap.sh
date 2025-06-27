# Install Homebrew
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Keyboard settings
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1
defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"

# Trackpad settings
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"

# git config
git config --global user.name "Chung Wei"
git config --global user.email leongchungwei@hotmail.com

# .zshrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc

# zed config
mkdir -p ~/.config/zed
ln -s ~/.dotfiles/.config/zed/settings.json ~/.config/zed/settings.json
ln -s ~/.dotfiles/.config/zed/keymap.json ~/.config/zed/keymap.json
ln -s ~/.dotfiles/.config/zed/tasks.json ~/.config/zed/tasks.json

# ghostty config
mkdir -p ~/.config/ghostty
ln -s ~/.dotfiles/.config/ghostty/config ~/.config/ghostty/config
ln -s ~/.dotfiles/.config/ghostty/themes ~/.config/ghostty

# brew
brew bundle --file ~/.dotfiles/Brewfile
