# .zshrc

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""   # disabled — starship controls the prompt

# Plugins — bundled with Oh My Zsh
plugins=(
  git
  z                         # jump to frecent dirs (no install needed)
  macos                     # macOS helpers (e.g. `ofd`, `pfd`)
  docker                    # completions
  npm                       # completions
  vscode                    # `code` shorthand helpers
  history                   # `h` alias for history search
  colored-man-pages
  tmux                      # aliases: ta, tl, ts, tksv, tkss
  zsh-autosuggestions       # cloned by install.sh
  zsh-syntax-highlighting   # cloned by install.sh (keep last)
)

source "$ZSH/oh-my-zsh.sh"

# ── Homebrew ──────────────────────────────────────────────────────────────────
# Apple Silicon path; Intel Macs use /usr/local
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── Path additions ────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Node (nvm) ────────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"
[ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && source "$(brew --prefix nvm)/etc/bash_completion.d/nvm"

# ── Python (pyenv) ────────────────────────────────────────────────────────────
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init -)"
fi

# ── fzf ──────────────────────────────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR="code --wait"
export VISUAL="$EDITOR"

# ── Aliases ───────────────────────────────────────────────────────────────────
# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"

# Listings (eza replaces ls)
alias ls="eza --icons"
alias ll="eza -lah --icons --git"
alias lt="eza --tree --icons --level=2"

# bat replaces cat
alias cat="bat"

# Git shortcuts (beyond what the git plugin provides)
alias g="git"
alias gs="git status -sb"
alias glog="git log --oneline --graph --decorate --all"

# Dotfiles shortcut
alias dotfiles="cd ~/dotfiles"
alias reload="source ~/.zshrc && echo 'Shell reloaded'"

# Homebrew
alias bup="brew update && brew upgrade && brew cleanup"

# ── Misc ──────────────────────────────────────────────────────────────────────
# Disable autocorrect (can be annoying in dev workflows)
DISABLE_CORRECTION="true"

# History settings
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# ── tmux ──────────────────────────────────────────────────────────────────────
# Automatically attach to (or create) a default session when opening iTerm2
# Comment this out if you prefer to start tmux manually
if [[ -z "$TMUX" ]] && command -v tmux &>/dev/null; then
  tmux attach -t main 2>/dev/null || tmux new-session -s main
fi

# ── Starship prompt ───────────────────────────────────────────────────────────
# Must be the very last line of .zshrc
command -v starship &>/dev/null && eval "$(starship init zsh)"
