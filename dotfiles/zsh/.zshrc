# ============================================================================
# ZSH Configuration - Part of dotfiles_wiz
# ============================================================================
# This is your main ZSH configuration file
# Customize to your heart's content!
# ============================================================================

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Path to dotfiles directory
export _dotfiles_dir="${HOME}/.dotfiles"

# ============================================================================
# Theme
# ============================================================================

ZSH_THEME="adlee"  # or robbyrussell, agnoster, etc.

# ============================================================================
# Oh-My-Zsh Plugins
# ============================================================================

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# ============================================================================
# Custom Configuration
# ============================================================================

# Add ~/.local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# ============================================================================
# Aliases
# ============================================================================

# Load aliases
[[ -f "$_dotfiles_dir/zsh/aliases.zsh" ]] && source "$_dotfiles_dir/zsh/aliases.zsh"

# ============================================================================
# Functions (Deferred Loading for Performance)
# ============================================================================

_deferred_load() {
    # Load dotfiles config
    local config_file="$_dotfiles_dir/dotfiles.conf"
    [[ -f "$config_file" ]] && source "$config_file"
    
    # Dotfiles CLI
    [[ -f "$_dotfiles_dir/zsh/functions/dotfiles-cli.zsh" ]] && \
        source "$_dotfiles_dir/zsh/functions/dotfiles-cli.zsh"
    
    # Analytics
    [[ -f "$_dotfiles_dir/zsh/functions/analytics.zsh" ]] && \
        source "$_dotfiles_dir/zsh/functions/analytics.zsh"
    
    # Vault (secrets management)
    [[ -f "$_dotfiles_dir/zsh/functions/vault.zsh" ]] && \
        source "$_dotfiles_dir/zsh/functions/vault.zsh"
    
    # MOTD (message of the day) - Core feature
    [[ -f "$_dotfiles_dir/zsh/functions/motd.zsh" ]] && \
        source "$_dotfiles_dir/zsh/functions/motd.zsh"
    
    # Python templates - Core feature
    [[ -f "$_dotfiles_dir/zsh/functions/python-templates.zsh" ]] && \
        source "$_dotfiles_dir/zsh/functions/python-templates.zsh"
    
    # SSH manager - Core feature
    [[ -f "$_dotfiles_dir/zsh/functions/ssh-manager.zsh" ]] && \
        source "$_dotfiles_dir/zsh/functions/ssh-manager.zsh"
    
    # Tmux workspaces - Core feature
    [[ -f "$_dotfiles_dir/zsh/functions/tmux-workspaces.zsh" ]] && \
        source "$_dotfiles_dir/zsh/functions/tmux-workspaces.zsh"
    
    # ========================================================================
    # Optional Features (controlled by dotfiles.conf)
    # ========================================================================
    
    # Command Palette - Fuzzy command launcher (requires fzf)
    if [[ "${ENABLE_COMMAND_PALETTE:-true}" == "true" ]]; then
        [[ -f "$_dotfiles_dir/zsh/functions/command-palette.zsh" ]] && \
            source "$_dotfiles_dir/zsh/functions/command-palette.zsh"
    fi
    
    # Password Manager Integration - Unified CLI for password managers
    if [[ "${ENABLE_PASSWORD_MANAGER:-true}" == "true" ]]; then
        [[ -f "$_dotfiles_dir/zsh/functions/password-manager.zsh" ]] && \
            source "$_dotfiles_dir/zsh/functions/password-manager.zsh"
    fi
    
    # Smart Suggest - Typo correction and command suggestions
    if [[ "${ENABLE_SMART_SUGGEST:-true}" == "true" ]]; then
        [[ -f "$_dotfiles_dir/zsh/functions/smart-suggest.zsh" ]] && \
            source "$_dotfiles_dir/zsh/functions/smart-suggest.zsh"
    fi
}

# Load functions in background (for faster shell startup)
if [[ "${DEFER_LOAD_FUNCTIONS:-true}" == "true" ]]; then
    # Defer loading by a fraction of a second
    ( sleep 0.1 && _deferred_load & )
else
    # Load immediately
    _deferred_load
fi

# ============================================================================
# MOTD (Message of the Day)
# ============================================================================

# Show system info on new shells (once per session)
if [[ -n "$PS1" ]] && command -v show_motd &>/dev/null; then
    show_motd
fi

# ============================================================================
# Custom Settings
# ============================================================================

# Editor
export EDITOR='vim'
export VISUAL='vim'

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Colors for ls
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Enable better completion
autoload -Uz compinit
compinit

# ============================================================================
# Welcome Message
# ============================================================================

# Uncomment to show a welcome message
# echo "Welcome to dotfiles_wiz! 🎉"
# echo "Type 'dfd' to check your setup"
