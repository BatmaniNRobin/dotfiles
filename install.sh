#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Starting dotfiles install..."

# ── 1. Xcode Command Line Tools ──────────────────────────────────────────────
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  # Wait for the installation to finish before continuing
  until xcode-select -p &>/dev/null; do sleep 5; done
fi

# ── 2. Homebrew ───────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for Apple Silicon Macs (if needed right now)
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

echo "==> Updating Homebrew..."
brew update

# ── 3. Install packages & apps via Brewfile ───────────────────────────────────
echo "==> Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ── 4. Oh My Zsh ─────────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "==> Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ── 5. Zsh plugins (not bundled with Oh My Zsh) ───────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_if_missing() {
  local repo="$1" dest="$2"
  if [[ ! -d "$dest" ]]; then
    echo "==> Cloning $(basename "$dest")..."
    git clone --depth=1 "$repo" "$dest"
  fi
}

clone_if_missing \
  https://github.com/zsh-users/zsh-autosuggestions \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

clone_if_missing \
  https://github.com/zsh-users/zsh-syntax-highlighting \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# ── 6. Symlink dotfiles ───────────────────────────────────────────────────────
symlink() {
  local src="$DOTFILES_DIR/$1" dst="$HOME/$1"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    echo "==> Backing up existing $dst → ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sf "$src" "$dst"
  echo "==> Linked $dst"
}

symlink .zshrc
symlink .gitconfig

# Starship config lives in ~/.config/starship.toml
mkdir -p "$HOME/.config"
if [[ -e "$HOME/.config/starship.toml" && ! -L "$HOME/.config/starship.toml" ]]; then
  echo "==> Backing up existing starship.toml"
  mv "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.bak"
fi
ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
echo "==> Linked ~/.config/starship.toml"

# tmux config
symlink .tmux.conf

# ── 7. Set Zsh as default shell ───────────────────────────────────────────────
ZSH_PATH="$(which zsh)"
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  echo "==> Setting zsh as default shell..."
  if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
  fi
  chsh -s "$ZSH_PATH"
fi

# ── 8. VS Code extensions ────────────────────────────────────────────────────
if command -v code &>/dev/null; then
  echo "==> Installing VS Code extensions..."
  # Read extension IDs from vscode-extensions.txt, skip blank lines and comments
  while IFS= read -r ext || [[ -n "$ext" ]]; do
    [[ -z "$ext" || "$ext" == \#* ]] && continue
    code --install-extension "$ext" --force
  done < "$DOTFILES_DIR/vscode-extensions.txt"
else
  echo "==> Skipping VS Code extensions (code CLI not found — VS Code may need to be opened once first)"
fi

# ── 9. fzf keybindings & completions ─────────────────────────────────────────
if command -v fzf &>/dev/null; then
  echo "==> Setting up fzf keybindings..."
  "$(brew --prefix fzf)/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# ── 10. Conda (miniconda) init ────────────────────────────────────────────────
CONDA_BIN="$HOME/miniconda3/bin/conda"
if [[ -f "$CONDA_BIN" ]]; then
  echo "==> Initialising conda for zsh..."
  "$CONDA_BIN" init zsh
  "$CONDA_BIN" config --set auto_activate_base false
else
  echo "==> Skipping conda init (miniconda3 not found — may need a shell restart after brew bundle)"
fi

# ── 11. Rectangle preferences ─────────────────────────────────────────────────
echo "==> Configuring Rectangle..."
# Gap between windows (pixels)
defaults write com.knollsoft.Rectangle gapSize -float 10
# Margin from screen edges (pixels) — Rectangle uses a single "margin" value
# applied to all four screen edges
defaults write com.knollsoft.Rectangle screenEdgeGapTop    -float 5
defaults write com.knollsoft.Rectangle screenEdgeGapBottom -float 5
defaults write com.knollsoft.Rectangle screenEdgeGapLeft   -float 5
defaults write com.knollsoft.Rectangle screenEdgeGapRight  -float 5
# Nudge Rectangle to re-read its prefs if it's already running
killall Rectangle &>/dev/null || true

# ── 12. macOS defaults (optional tweaks) ──────────────────────────────────────
echo "==> Applying macOS defaults..."

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show file extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

killall Finder &>/dev/null || true

echo ""
echo "✓ Dotfiles installed! Open a new terminal session to load your shell config."
