#!/usr/bin/env bash
set -euo pipefail

DOTFORGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
WARNINGS=()

warn() {
  echo "WARNING: $1" >&2
  WARNINGS+=("$1")
}

link() {
  local src="$DOTFORGE_DIR/$1"
  local dest="$HOME/$2"

  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Backing up existing $dest -> $dest.bak"
    mv "$dest" "$dest.bak"
  fi

  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  if [ "$OS" != "Linux" ]; then
    echo "Homebrew not found. Install it from https://brew.sh first." >&2
    exit 1
  fi

  echo "Homebrew not found. Installing Homebrew (Linuxbrew)..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  local brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"
  [ -x "$brew_bin" ] || brew_bin="$HOME/.linuxbrew/bin/brew"
  eval "$("$brew_bin" shellenv)"
}

ensure_nerd_font_linux() {
  # Not grep -q: exiting early SIGPIPEs fc-list, which fails under pipefail.
  if fc-list 2>/dev/null | grep -i "JetBrainsMono Nerd Font" >/dev/null; then
    return
  fi

  echo "Installing JetBrainsMono Nerd Font..."
  local font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
  # Chained with && since set -e is off when called as `ensure_nerd_font_linux || ...`
  mkdir -p "$font_dir" &&
    curl -fsSL -o /tmp/JetBrainsMono.zip \
      "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" &&
    unzip -oq /tmp/JetBrainsMono.zip -d "$font_dir" &&
    rm /tmp/JetBrainsMono.zip &&
    fc-cache -f "$font_dir" >/dev/null
}

# System packages need sudo, so only check for them and say what to run.
check_linux_prereqs() {
  local missing=()
  command -v zsh >/dev/null 2>&1 || missing+=("zsh")
  command -v cc >/dev/null 2>&1 || missing+=("build-essential")
  command -v fc-cache >/dev/null 2>&1 || missing+=("fontconfig")

  if [ ${#missing[@]} -gt 0 ]; then
    warn "Missing system packages (bun needs a C compiler). Run: sudo apt install -y ${missing[*]}"
  fi
}

# Manual git install from https://github.com/nvm-sh/nvm#manual-install, which
# unlike nvm's install script doesn't append to shell profiles.
ensure_nvm() {
  local nvm_dir="$HOME/.nvm"
  if [ -s "$nvm_dir/nvm.sh" ]; then
    return
  fi

  echo "Installing nvm..."
  git clone -q https://github.com/nvm-sh/nvm.git "$nvm_dir"
  git -C "$nvm_dir" checkout -q \
    "$(git -C "$nvm_dir" describe --abbrev=0 --tags --match "v[0-9]*" "$(git -C "$nvm_dir" rev-list --tags --max-count=1)")"
}

bundle() {
  echo "Installing packages from $1..."
  brew bundle --file="$DOTFORGE_DIR/$1" || warn "Some packages from $1 failed to install. Re-run: brew bundle --file=$DOTFORGE_DIR/$1"
}

if [ "$OS" = "Linux" ]; then
  check_linux_prereqs
fi

ensure_homebrew

# Homebrew refuses to load formulae from untrusted third-party taps.
brew trust --tap oven-sh/bun || warn "Could not trust the oven-sh/bun tap; bun may fail to install"

bundle "Brewfile"

if [ "$OS" = "Darwin" ]; then
  bundle "Brewfile.mac"
else
  ensure_nerd_font_linux || warn "Nerd Font install failed"
fi

ensure_nvm || warn "nvm install failed"

echo "Linking dotfiles..."
link ".zshrc" ".zshrc"
link ".aliases" ".aliases"
link ".gitconfig" ".gitconfig"
link "starship.toml" ".config/starship.toml"
link "ghostty/config" ".config/ghostty/config"

if [ ${#WARNINGS[@]} -gt 0 ]; then
  echo
  echo "Finished with warnings:"
  printf '  - %s\n' "${WARNINGS[@]}"
fi

echo "Done. Restart your shell or run: source ~/.zshrc"
