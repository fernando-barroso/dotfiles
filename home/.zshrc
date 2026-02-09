# ~/.zshrc
# Managed via ~/dotfiles — edit there, not here

# ─── Powerlevel10k Instant Prompt ────────────────────────────
# Must stay at the top. Initialization code that may require
# console input must go above this block.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Fix for Cursor terminal hanging with Powerlevel10k
if [[ -n $CURSOR_TRACE_ID ]]; then
  PROMPT_EOL_MARK=""
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
  precmd() { print -Pn "\e]133;D;%?\a" }
  preexec() { print -Pn "\e]133;C;\a" }
fi

# ─── Homebrew ────────────────────────────────────────────────
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# ─── Prompt ──────────────────────────────────────────────────
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ─── Navigation ──────────────────────────────────────────────
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# ─── Per-project env ─────────────────────────────────────────
eval "$(direnv hook zsh)"

# ─── Plugins ─────────────────────────────────────────────────
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ─── Environment ─────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
export XDG_CONFIG_HOME="$HOME/.config"

# ─── Path ────────────────────────────────────────────────────
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$HOME/.local/bin:$PNPM_HOME:$PATH"

# ─── Aliases ─────────────────────────────────────────────────
alias ls="eza"
alias ll="eza -la --git"
alias lt="eza -la --tree --level=2"
alias cat="bat"
alias lg="lazygit"
alias top="btop"
alias dev="cd ~/dev"
alias dots="cd ~/dotfiles"

# ─── History ─────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
