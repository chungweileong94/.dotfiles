# .dotfiles

A collection of configuration files (dotfiles) for various tools and applications.

### Installation

```bash
git clone https://github.com/chungweileong94/.dotfiles.git && source ~/.dotfiles/bootstrap.sh
```

### Devices-specific zsh config
Put the device-specific zsh config under `~/.zsh/extra`.

### Git profiles
The first time `bootstrap.sh` runs, it prompts for a personal name+email, a work
name+email, and which one should be the default, then saves them to
`~/.dotfiles/.git-profiles.env` and applies the default via `git config --global`.

Inside any repo, switch the local (non-global) identity with:

```bash
git-profile-personal
git-profile-work
```

To change the saved name/email or the default profile, either edit
`~/.dotfiles/.git-profiles.env` directly, or delete it and re-run `bootstrap.sh` to be
prompted again:

```bash
rm ~/.dotfiles/.git-profiles.env && source ~/.dotfiles/bootstrap.sh
```
