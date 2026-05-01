# .zshrc

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""   # disabled — starship controls the prompt

# Load plugins from separate file — edit zsh/plugins.zsh to add/remove
source "${ZDOTDIR:-$HOME}/dotfiles/zsh/plugins.zsh"

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

# ── zoxide (replaces z plugin) ────────────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
# Use `z <dir>` to jump, `zi` for interactive fuzzy picker (requires fzf)

# ── Conda (miniconda) ─────────────────────────────────────────────────────────
# Conda is initialised here but auto-activation of base is disabled —
# activate environments explicitly with `conda activate <env>`
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"
if [[ $? -eq 0 ]]; then
  eval "$__conda_setup"
elif [[ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]]; then
  source "$HOME/miniconda3/etc/profile.d/conda.sh"
fi
unset __conda_setup
conda config --set auto_activate_base false 2>/dev/null || true

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
alias lg="lazygit"

# tldr before man for quick examples
alias help="tldr"

# btop for system monitoring
alias top="btop"

# Dotfiles shortcut
alias dotfiles="cd ~/dotfiles"
alias reload="source ~/.zshrc && echo 'Shell reloaded'"

# Homebrew
alias bup="brew update && brew upgrade && brew cleanup"

# terraform
alias tf="terraform"

# watch
alias wkgp="watch kubectl get pods"

# istio
alias kgvs="kubectl get virtualservices"
alias kdvs="kubectl get destinationrules"
alias kgdr="kubectl get destinationrules"
alias kddr="kubectl describe destinationrules"
alias kgpeer="kubectl get peerauthentication"
alias kdpeer="kubectl describe peerauthentication"

# external secrets operator
alias kges="kubectl get externalsecrets"
alias kdes="kubectl describe externalsecrets"
alias kgcss="kubectl get clustersecretstore"
alias kdcss="kubectl describe clustersecretstore"

# flux
alias kghr="kubectl get helmreleases"
alias kdhr="kubectl describe helmreleases"
alias kgoci="kubectl get ocirepositories"
alias kdoci="kubectl describe ocirepositories"


# ── Misc ──────────────────────────────────────────────────────────────────────
# Disable autocorrect (can be annoying in dev workflows)
DISABLE_CORRECTION="true"

# History settings
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/mani/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/mani/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/mani/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/mani/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# ── tmux ──────────────────────────────────────────────────────────────────────
# Automatically attach to (or create) a default session when opening iTerm2
# Comment this out if you prefer to start tmux manually
if [[ -z "$TMUX" ]] && command -v tmux &>/dev/null; then
  tmux attach -t main 2>/dev/null || tmux new-session -s main
fi

neofetch

# ── Starship prompt ───────────────────────────────────────────────────────────
# Must be the very last line of .zshrc
command -v starship &>/dev/null && eval "$(starship init zsh)"
