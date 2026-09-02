# -----------------------------------------
# Environment
# -----------------------------------------

export EDITOR="vim"
export VISUAL="$EDITOR"


# -----------------------------------------
# pnpm
# -----------------------------------------

export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac


# -----------------------------------------
# History
# -----------------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS


# -----------------------------------------
# Completion
# -----------------------------------------

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select


# -----------------------------------------
# Aliases
# -----------------------------------------

[[ -f ~/.aliases ]] && source ~/.aliases


# -----------------------------------------
# CLI productivity
# -----------------------------------------

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

# -----------------------------------------
# Prompt
# -----------------------------------------
eval "$(starship init zsh)"


# -----------------------------------------
# Zsh enhancements
# -----------------------------------------
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Keep syntax highlighting last
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
