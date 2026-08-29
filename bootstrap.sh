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

# Git config
git config --global user.name "Chung Wei"
git config --global user.email leongchungwei@hotmail.com

# .zshrc
ln -sfn ~/.dotfiles/.zshrc ~/.zshrc
source ~/.zshrc

# .zshenv
ln -sfn ~/.dotfiles/.zshenv ~/.zshenv

# Zed config
mkdir -p ~/.config/zed
ln -sfn ~/.dotfiles/.config/zed/settings.json ~/.config/zed/settings.json
ln -sfn ~/.dotfiles/.config/zed/keymap.json ~/.config/zed/keymap.json
ln -sfn ~/.dotfiles/.config/zed/tasks.json ~/.config/zed/tasks.json

# Ghostty config
mkdir -p ~/.config/ghostty
ln -sfn ~/.dotfiles/.config/ghostty/config ~/.config/ghostty/config
ln -sfn ~/.dotfiles/.config/ghostty/themes ~/.config/ghostty/themes

# Codex config
mkdir -p ~/.codex
ln -sfn ~/.dotfiles/.codex/pets ~/.codex/pets

# Claude Code config
mkdir -p ~/.claude
ln -sfn ~/.dotfiles/.claude/settings.json ~/.claude/settings.json
ln -sfn ~/.dotfiles/.claude/statusline-command.sh ~/.claude/statusline-command.sh

# Brew
brew bundle --file ~/.dotfiles/Brewfile
brew-upgrade

# Install Vite Plus
if ! command -v vp &>/dev/null; then
  curl -fsSL https://vite.plus | bash
fi
