#!/usr/bin/env zsh

# Prints a "==> $name..." banner, then runs the given function.
section() {
  local name="$1"
  shift
  echo "==> $name..."
  "$@"
}

# Creates a symlink at $2 pointing to $1, skipping (with a warning) if
# something already exists there.
link() {
  local src="$1" dest="$2"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "\033[33mwarning: $dest already exists, skipping\033[0m" >&2
    return
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
}

install_homebrew() {
  if command -v brew &>/dev/null; then
    echo "\033[34minfo: Homebrew is already installed, skipping\033[0m"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

link_zshrc() {
  link ~/.dotfiles/.zshrc ~/.zshrc
  source ~/.zshrc
}

link_zshenv() {
  link ~/.dotfiles/.zshenv ~/.zshenv
}

configure_keyboard() {
  defaults write -g InitialKeyRepeat -int 15
  defaults write -g KeyRepeat -int 1
  defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"
}

configure_trackpad() {
  defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"
}

configure_git() {
  local profiles_file=~/.dotfiles/.git-profiles.env

  if [ ! -f "$profiles_file" ]; then
    echo "Setting up git profiles (saved locally, never committed)..."
    read "personal_name?Personal git name: "
    read "personal_email?Personal git email: "
    read "work_name?Work git name: "
    read "work_email?Work git email: "
    read "default_profile?Default profile, personal or work [personal]: "
    default_profile=${default_profile:-personal}

    cat > "$profiles_file" <<EOF
GIT_PERSONAL_NAME="$personal_name"
GIT_PERSONAL_EMAIL="$personal_email"
GIT_WORK_NAME="$work_name"
GIT_WORK_EMAIL="$work_email"
GIT_DEFAULT_PROFILE="$default_profile"
EOF
  fi

  source "$profiles_file"
  if [ "$GIT_DEFAULT_PROFILE" = "work" ]; then
    git config --global user.name "$GIT_WORK_NAME"
    git config --global user.email "$GIT_WORK_EMAIL"
  else
    git config --global user.name "$GIT_PERSONAL_NAME"
    git config --global user.email "$GIT_PERSONAL_EMAIL"
  fi
}

link_zed_config() {
  link ~/.dotfiles/.config/zed/settings.json ~/.config/zed/settings.json
  link ~/.dotfiles/.config/zed/keymap.json ~/.config/zed/keymap.json
  link ~/.dotfiles/.config/zed/tasks.json ~/.config/zed/tasks.json
}

link_ghostty_config() {
  link ~/.dotfiles/.config/ghostty/config ~/.config/ghostty/config
  link ~/.dotfiles/.config/ghostty/themes ~/.config/ghostty/themes
}

link_codex_config() {
  link ~/.dotfiles/.codex/pets ~/.codex/pets
}

link_claude_config() {
  link ~/.dotfiles/.claude/settings.json ~/.claude/settings.json
  link ~/.dotfiles/.claude/statusline-command.sh ~/.claude/statusline-command.sh
}

install_brew_packages() {
  brew bundle --file ~/.dotfiles/Brewfile
  brew-upgrade
}

install_vite_plus() {
  if command -v vp &>/dev/null; then
    echo "\033[34minfo: Vite Plus is already installed, skipping\033[0m"
  else
    curl -fsSL https://vite.plus | bash
  fi
}

section "Installing Homebrew" install_homebrew
section "Linking .zshrc" link_zshrc
section "Linking .zshenv" link_zshenv
section "Configuring keyboard settings" configure_keyboard
section "Configuring trackpad settings" configure_trackpad
section "Configuring git" configure_git
section "Linking Zed config" link_zed_config
section "Linking Ghostty config" link_ghostty_config
section "Linking Codex config" link_codex_config
section "Linking Claude Code config" link_claude_config
section "Installing Brewfile packages" install_brew_packages
section "Installing Vite Plus" install_vite_plus
