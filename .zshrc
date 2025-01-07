# antigen
if [[ ! -f ${ZDOTDIR:-${HOME}}/.antigen/bin/antigen.zsh ]]; then
  git clone https://github.com/zsh-users/antigen.git ${ZDOTDIR:-${HOME}}/.antigen/bin
fi
source ${ZDOTDIR:-${HOME}}/.antigen/bin/antigen.zsh
antigen use oh-my-zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme chungweileong94/zsh-theme@custom
antigen apply
# antigen end

# aliases
alias cat="bat --paging=never"
alias git-fetch="git fetch --all --prune"
alias git-delete-merged="git branch --merged | egrep -v \"(^\*|master|main|staging|dev|development)\" | xargs git branch -d"
alias git-profile-personal="git config user.name \"Chung Wei\" && git config user.email leongchungwei@hotmail.com"
alias git-profile-work="git config user.name \"Chung Wei\" && git config user.email chungwei@whiteroom.work"
# aliases end

# zed
export ELECTRON_RUN_AS_NODE=1
# zed end

# fnm
eval "$(fnm env --use-on-cd)"
# fnm end

