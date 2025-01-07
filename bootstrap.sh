# .zshrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc

# zed config
mkdir -p ~/.config/zed
ln -s ~/.dotfiles/.config/zed/settings.json ~/.config/zed/settings.json
ln -s ~/.dotfiles/.config/zed/keymap.json ~/.config/zed/keymap.json

# ghostty config
mkdir -p ~/.config/ghostty
ln -s ~/.dotfiles/.config/ghostty/config ~/.config/ghostty/config
ln -s ~/.dotfiles/.config/ghostty/themes ~/.config/ghostty/themes
