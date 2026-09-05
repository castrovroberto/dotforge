# dotforge

Personal terminal setup: zsh config, aliases, git config, Starship prompt, and
Ghostty config. Originally macOS-only, now also supported on Linux (via
Homebrew/Linuxbrew).

## Setup

```sh
git clone <this-repo> ~/dev/dotforge
cd ~/dev/dotforge
brew trust oven-sh/bun   # one-time: Homebrew requires explicit trust for this tap
./install.sh
```

`install.sh` will:

- Install Homebrew itself if it's missing (macOS: point you to https://brew.sh;
  Linux: install Linuxbrew automatically)
- Install everything in `Brewfile`, plus `Brewfile.mac` casks on macOS
- On Linux, install JetBrainsMono Nerd Font if no Nerd Font is already present
- Symlink the dotfiles into `$HOME` (existing files are backed up with a
  `.bak` suffix)

## Manually reinstalling packages

```sh
brew bundle --file=Brewfile
brew bundle --file=Brewfile.mac   # macOS only
```

## Contents

- `.zshrc` — shell config (history, completion, prompt, tool integrations)
- `.aliases` — shell aliases
- `.gitconfig` — git config (delta pager, zdiff3 merge style)
- `starship.toml` — prompt config
- `ghostty/config` — Ghostty terminal config (symlinked to `~/.config/ghostty/config`)
- `Brewfile` — cross-platform Homebrew formulae
- `Brewfile.mac` — macOS-only casks (Docker Desktop, Nerd Font)

## Machine-specific git identity

`.gitconfig` doesn't contain `user.name`/`user.email` since it's shared across
machines. It includes `~/.gitconfig.local`, which is *not* tracked by this
repo — set your identity there on each machine:

```sh
cat > ~/.gitconfig.local <<EOF
[user]
	email = you@example.com
	name = Your Name
EOF
```
