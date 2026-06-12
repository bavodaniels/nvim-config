#!/usr/bin/env bash
#
# Install this Neovim configuration on a new machine.
#
# - Backs up any existing ~/.config/nvim
# - Symlinks this repo to ~/.config/nvim
# - Restores plugins at the versions pinned in lazy-lock.json
#
# Usage: ./install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33mwarning:\033[0m %s\n' "$*"; }
error() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# --- Required tools -----------------------------------------------------------

command -v git >/dev/null 2>&1 || error "git is required but not installed."
command -v nvim >/dev/null 2>&1 || error "neovim is required but not installed.
  macOS:  brew install neovim
  Ubuntu: sudo apt install neovim (or use the unstable PPA for a recent version)"

NVIM_VERSION="$(nvim --version | head -n1 | sed 's/^NVIM v//')"
NVIM_MINOR="$(printf '%s' "$NVIM_VERSION" | cut -d. -f2)"
if [ "${NVIM_MINOR:-0}" -lt 10 ]; then
  error "neovim >= 0.10 is required (found $NVIM_VERSION)."
fi
info "Found neovim $NVIM_VERSION"

# --- Optional tools -----------------------------------------------------------

command -v rg >/dev/null 2>&1 || warn "ripgrep not found — telescope live grep won't work. (brew install ripgrep / apt install ripgrep)"
command -v cc >/dev/null 2>&1 || command -v gcc >/dev/null 2>&1 || warn "No C compiler found — treesitter parsers can't compile."
command -v node >/dev/null 2>&1 || warn "Node.js not found — some Mason-managed LSP servers need it."
command -v java >/dev/null 2>&1 || warn "Java not found — install JDK 17+ for the Java toolchain (jdtls)."

# --- Link config ----------------------------------------------------------------

if [ -L "$NVIM_CONFIG_DIR" ] && [ "$(readlink "$NVIM_CONFIG_DIR")" = "$REPO_DIR" ]; then
  info "~/.config/nvim already points at this repo, skipping link step."
else
  if [ -e "$NVIM_CONFIG_DIR" ]; then
    BACKUP="$NVIM_CONFIG_DIR.backup.$(date +%Y%m%d%H%M%S)"
    info "Backing up existing config to $BACKUP"
    mv "$NVIM_CONFIG_DIR" "$BACKUP"
  fi
  mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
  info "Linking $REPO_DIR -> $NVIM_CONFIG_DIR"
  ln -s "$REPO_DIR" "$NVIM_CONFIG_DIR"
fi

# --- Install plugins ------------------------------------------------------------

info "Installing plugins at pinned versions (lazy-lock.json)..."
nvim --headless "+Lazy! restore" +qa

info "Done. Launch nvim — Mason will install LSP servers and the Java debug tooling on first start."
