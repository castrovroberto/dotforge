# dotforge

Personal macOS terminal setup: zsh config, aliases, git config, and a Starship prompt.

## Setup

On a new Mac, with [Homebrew](https://brew.sh) installed:

```sh
git clone <this-repo> ~/dev/dotforge
cd ~/dev/dotforge
brew trust oven-sh/bun   # one-time: Homebrew requires explicit trust for this tap
./install.sh
```

This installs everything in `Brewfile` and symlinks the dotfiles into `$HOME`
(existing files are backed up with a `.bak` suffix).

## Manually reinstalling packages

```sh
brew bundle --file=Brewfile
```

## Contents

- `.zshrc` — shell config (history, completion, prompt, tool integrations)
- `.aliases` — shell aliases
- `.gitconfig` — git config (delta pager, zdiff3 merge style)
- `starship.toml` — prompt config
- `Brewfile` — all Homebrew formulae/casks this setup depends on
