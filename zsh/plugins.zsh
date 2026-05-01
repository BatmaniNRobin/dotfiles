# zsh/plugins.zsh
# Edit this file to add or remove Oh My Zsh plugins.
# The `plugins` array must be set before `oh-my-zsh.sh` is sourced in .zshrc.

plugins=(
  git
  git-extras
  macos                     # macOS helpers (e.g. `ofd`, `pfd`)
  podman                    # completions
  docker                    # completions
  kubectl                   # completions
  npm                       # completions
  vscode                    # `code` shorthand helpers
  history                   # `h` alias for history search
  colored-man-pages
  colorize
  jsontools                 # query | pp_json pretty prints json output
  web-search                # shortcut for searching the web (e.g. google question, sp question)
  thefuck                   # corrects previous command when you type `fuck` (or just `f`) — must be last to work
  tailscale                 # completions
  istioctl                  # completions
  tmux                      # aliases: ta, tl, ts, tksv, tkss
  zsh-autosuggestions       # cloned by install.sh
  zsh-syntax-highlighting   # cloned by install.sh — must stay last
  zsh-interactive-cd
  zsh-navigation-tools
)
