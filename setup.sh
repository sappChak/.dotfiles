#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
TARGET_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.dotfiles_backup"

PACKAGES=(
    alacritty
    ghostty
    i3
    kitty
    nvim
    tmux
    zsh
)

usage() {
    echo "Usage: $(basename "$0") [--all | --only <pkg1> <pkg2> ...]"
    exit 1
}

# Ensure GNU stow is installed
if ! command -v stow &>/dev/null; then
    echo "❌ stow not found!"
    if grep -qi arch /etc/os-release; then
        echo "→ Installing stow with pacman..."
        sudo pacman -Sy --needed stow
    else
        echo "Please install stow manually."
        exit 1
    fi
fi

# Backup function
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "⚠️  Backing up existing $target → $BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
    fi
}

# Parse args
if [[ $# -eq 0 ]]; then
    usage
fi

case "$1" in
    --all)
        SELECTED_PKGS=("${PACKAGES[@]}")
        ;;
    --only)
        shift
        [[ $# -eq 0 ]] && usage
        SELECTED_PKGS=("$@")
        ;;
    *)
        usage
        ;;
esac

echo "📂 Dotfiles directory: $DOTFILES_DIR"
echo "🎯 Target config dir: $TARGET_DIR"
echo "📦 Packages to stow: ${SELECTED_PKGS[*]}"
echo

cd "$DOTFILES_DIR" || {
    echo "❌ Failed to cd into $DOTFILES_DIR"
    exit 1
}

for pkg in "${SELECTED_PKGS[@]}"; do
    echo "→ Preparing $pkg"
    mkdir -p "$TARGET_DIR/$pkg"   # ensure folder exists
    backup_if_exists "$TARGET_DIR/$pkg"
    echo "→ Stowing $pkg"
    stow -v -t "$TARGET_DIR/$pkg" "$pkg"
done

echo
echo "✅ All selected packages have been stowed successfully."
