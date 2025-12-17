#!/usr/bin/env bash
# Copy optional features from personal dotfiles
set -e

PERSONAL_DOTFILES="${1:-$HOME/dotfiles}"
BUNDLE_FUNCTIONS="$(dirname "$0")/../dotfiles/zsh/functions"

if [[ ! -d "$PERSONAL_DOTFILES" ]]; then
    echo "Error: Personal dotfiles not found: $PERSONAL_DOTFILES"
    echo "Usage: $0 [path-to-personal-dotfiles]"
    exit 1
fi

echo "Copying optional features..."

# Copy files
for feature in command-palette.zsh password-manager.zsh smart-suggest.zsh; do
    src="$PERSONAL_DOTFILES/zsh/functions/$feature"
    if [[ -f "$src" ]]; then
        cp "$src" "$BUNDLE_FUNCTIONS/$feature"
        echo "✓ $feature"
    else
        echo "✗ $feature (not found)"
    fi
done

echo "Done! Now rebuild: tar -czf dotfiles_wiz.tar.gz dotfiles_wiz/"
