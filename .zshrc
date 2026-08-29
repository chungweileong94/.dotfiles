# antigen
if [[ ! -f ${ZDOTDIR:-${HOME}}/.antigen/bin/antigen.zsh ]]; then
  git clone https://github.com/zsh-users/antigen.git ${ZDOTDIR:-${HOME}}/.antigen/bin
fi
source ${ZDOTDIR:-${HOME}}/.antigen/bin/antigen.zsh
antigen use oh-my-zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme chungweileong94/zsh-theme
antigen apply
# antigen end

# aliases
alias cat="bat --paging=never"
alias git-fetch="git fetch --all --prune"
alias git-delete-merged="git branch --merged | egrep -v \"(^\*|master|main|staging|dev|development)\" | xargs git branch -d"
# aliases end

# git profiles (personal/work name+email, read from a gitignored file
# created by bootstrap.sh so identities never get committed)
git-profile-personal() {
  if [ ! -f ~/.dotfiles/.git-profiles.env ]; then
    echo "no ~/.dotfiles/.git-profiles.env found, run bootstrap.sh first" >&2
    return 1
  fi
  source ~/.dotfiles/.git-profiles.env
  git config user.name "$GIT_PERSONAL_NAME"
  git config user.email "$GIT_PERSONAL_EMAIL"
}

git-profile-work() {
  if [ ! -f ~/.dotfiles/.git-profiles.env ]; then
    echo "no ~/.dotfiles/.git-profiles.env found, run bootstrap.sh first" >&2
    return 1
  fi
  source ~/.dotfiles/.git-profiles.env
  git config user.name "$GIT_WORK_NAME"
  git config user.email "$GIT_WORK_EMAIL"
}

# homebrew
# Disable auto updates for casks, it causes too much issues
export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS=1
# homebrew end

# Hombrew upgrade helper, which also remove quarantine attr from codex and claude-code
brew-upgrade() {
  echo "==> Upgrading Homebrew packages..."
  brew upgrade || return

  echo "==> Removing unused dependencies..."
  brew autoremove || return

  echo "==> Cleaning up old versions..."
  brew cleanup || return

  echo "==> Requesting sudo access for quarantine removal..."
  sudo -v || return

  echo "==> Removing quarantine attributes..."

  for cask in \
    codex \
    claude-code@latest
  do
    local cask_path="$(brew --prefix)/Caskroom/$cask"

    if [[ -d "$cask_path" ]]; then
      echo "    - $cask"
      sudo xattr -dr com.apple.quarantine "$cask_path"
    else
      echo "    - $cask not installed, skipping"
    fi
  done

  echo "==> Done."
}

# vite-plus
. "$HOME/.config/vite-plus/env"
# vite-plus env

# device-specific config
if [ -f ~/.zsh/extra ]; then
  source ~/.zsh/extra
fi
