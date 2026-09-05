#!/usr/bin/env bash
set -euo pipefail

DOTFORGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

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
  if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font"; then
    return
  fi

  echo "Installing JetBrainsMono Nerd Font..."
  local font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
  mkdir -p "$font_dir"
  curl -fsSL -o /tmp/JetBrainsMono.zip \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  unzip -oq /tmp/JetBrainsMono.zip -d "$font_dir"
  rm /tmp/JetBrainsMono.zip
  fc-cache -f "$font_dir" >/dev/null
}

ensure_homebrew

echo "Installing packages from Brewfile..."
brew bundle --file="$DOTFORGE_DIR/Brewfile"

if [ "$OS" = "Darwin" ]; then
  echo "Installing macOS-only packages from Brewfile.mac..."
  brew bundle --file="$DOTFORGE_DIR/Brewfile.mac"
else
  ensure_nerd_font_linux
fi

echo "Linking dotfiles..."
link ".zshrc" ".zshrc"
link ".aliases" ".aliases"
link ".gitconfig" ".gitconfig"
link "starship.toml" ".config/starship.toml"
link "ghostty/config" ".config/ghostty/config"

echo "Done. Restart your shell or run: source ~/.zshrc"
