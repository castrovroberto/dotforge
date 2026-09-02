#!/usr/bin/env bash
set -euo pipefail

DOTFORGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$DOTFORGE_DIR/$1"
  local dest="$HOME/$1"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Backing up existing $dest -> $dest.bak"
    mv "$dest" "$dest.bak"
  fi

  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install it from https://brew.sh first." >&2
  exit 1
fi

echo "Installing packages from Brewfile..."
brew bundle --file="$DOTFORGE_DIR/Brewfile"

echo "Linking dotfiles..."
link ".zshrc"
link ".aliases"
link ".gitconfig"

mkdir -p "$HOME/.config"
ln -sfn "$DOTFORGE_DIR/starship.toml" "$HOME/.config/starship.toml"
echo "Linked $HOME/.config/starship.toml -> $DOTFORGE_DIR/starship.toml"

echo "Done. Restart your shell or run: source ~/.zshrc"
