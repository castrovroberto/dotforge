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

## Known gotchas

- **Stale `/etc/environment` `JAVA_HOME`:** this repo's `.zshrc` manages
  `JAVA_HOME` via SDKMAN, but `/etc/environment` is system-wide and not
  managed by dotforge. If a JDK was ever installed manually (e.g. via apt)
  and later removed, a leftover `JAVA_HOME=` line there can point at a path
  that no longer exists. Interactive shells won't notice (`.zshrc`'s export
  wins), but non-login-shell contexts that only read `/etc/environment`
  (IDEs, systemd services, cron) will pick up the stale value. Check with
  `cat /etc/environment` and remove any `JAVA_HOME=` line by hand (`sudo`
  required — not something `install.sh` touches).

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
