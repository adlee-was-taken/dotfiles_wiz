#!/usr/bin/env bash
# ============================================================================
# ADLee's Dotfiles Setup Wizard
# ============================================================================
# Interactive first-time setup and configuration
# ============================================================================

set -e

# ============================================================================
# Colors
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# ============================================================================
# Configuration
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$DOTFILES_DIR/dotfiles.conf"

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}                                                            ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  ${CYAN}✨ Dotfiles Setup Wizard ✨${NC}                          ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}                                                            ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  Let's configure your perfect development environment!    ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}                                                            ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"
}

print_section() {
    echo -e "\n${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}▶${NC} $1"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_step() {
    echo -e "${GREEN}→${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

ask_yes_no() {
    local prompt="$1"
    local default="${2:-y}"
    local response

    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    read -p "$(echo -e "${CYAN}?${NC} $prompt")" response
    response=${response:-$default}
    [[ "$response" =~ ^[Yy]$ ]]
}

ask_input() {
    local prompt="$1"
    local default="$2"
    local response

    if [[ -n "$default" ]]; then
        prompt="$prompt [$default]: "
    else
        prompt="$prompt: "
    fi

    read -p "$(echo -e "${CYAN}?${NC} $prompt")" response
    echo "${response:-$default}"
}

ask_choice() {
    local prompt="$1"
    shift
    local options=("$@")
    
    echo -e "${CYAN}?${NC} $prompt"
    for i in "${!options[@]}"; do
        echo -e "  ${GREEN}$((i+1)).${NC} ${options[$i]}"
    done
    
    local choice
    while true; do
        read -p "$(echo -e "${CYAN}→${NC} Enter choice [1-${#options[@]}]: ")" choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo "$((choice-1))"
            return 0
        fi
        print_warning "Invalid choice. Please enter a number between 1 and ${#options[@]}"
    done
}

press_enter() {
    echo
    read -p "$(echo -e "${CYAN}→${NC} Press Enter to continue...")"
}

# ============================================================================
# Setup Stages
# ============================================================================

stage_welcome() {
    print_header
    
    cat << EOF
Welcome to the interactive setup wizard! 🎉

This wizard will help you:
  • Configure your personal information
  • Set up git and development tools
  • Choose which features to enable
  • Configure SSH connections
  • Create tmux workspaces
  • Set up Python development templates
  • Install optional tools

The whole process takes about 5-10 minutes.

${YELLOW}Note:${NC} You can always re-run this wizard later with:
  ${CYAN}./setup/setup-wizard.sh${NC}

EOF

    if ! ask_yes_no "Ready to begin?"; then
        echo
        print_warning "Setup cancelled. Run this script again when ready!"
        exit 0
    fi
}

stage_personal_info() {
    print_section "Personal Information"
    
    print_info "This information will be used in your git config and documentation."
    echo
    
    USER_FULLNAME=$(ask_input "Your full name" "${USER_FULLNAME:-$(git config --global user.name 2>/dev/null || echo '')}")
    USER_EMAIL=$(ask_input "Your email address" "${USER_EMAIL:-$(git config --global user.email 2>/dev/null || echo '')}")
    
    print_success "Personal info saved"
}

stage_git_config() {
    print_section "Git Configuration"
    
    print_info "Let's configure your git settings."
    echo
    
    GIT_USER_NAME="${USER_FULLNAME}"
    GIT_USER_EMAIL="${USER_EMAIL}"
    
    GIT_DEFAULT_BRANCH=$(ask_input "Default branch name" "${GIT_DEFAULT_BRANCH:-main}")
    
    echo
    print_info "Choose a credential helper:"
    echo "  ${GREEN}1.${NC} store - Saves passwords in plain text (simple, less secure)"
    echo "  ${GREEN}2.${NC} cache - Keeps passwords in memory temporarily"
    echo "  ${GREEN}3.${NC} osxkeychain - macOS Keychain (macOS only)"
    echo "  ${GREEN}4.${NC} manager - Git Credential Manager (cross-platform)"
    
    local cred_choice=$(ask_choice "Choose credential helper" "store" "cache" "osxkeychain" "manager")
    case "$cred_choice" in
        0) GIT_CREDENTIAL_HELPER="store" ;;
        1) GIT_CREDENTIAL_HELPER="cache" ;;
        2) GIT_CREDENTIAL_HELPER="osxkeychain" ;;
        3) GIT_CREDENTIAL_HELPER="manager" ;;
    esac
    
    print_success "Git configuration complete"
}

stage_shell_preferences() {
    print_section "Shell Preferences"
    
    print_info "Customize your shell experience."
    echo
    
    # Theme selection
    print_step "Available ZSH themes:"
    echo "  ${GREEN}1.${NC} adlee - Custom theme with git info (default)"
    echo "  ${GREEN}2.${NC} robbyrussell - oh-my-zsh classic"
    echo "  ${GREEN}3.${NC} agnoster - Powerline style"
    echo "  ${GREEN}4.${NC} powerlevel10k - Advanced, fast theme"
    
    local theme_choice=$(ask_choice "Choose theme" "adlee" "robbyrussell" "agnoster" "powerlevel10k")
    case "$theme_choice" in
        0) ZSH_THEME_NAME="adlee" ;;
        1) ZSH_THEME_NAME="robbyrussell" ;;
        2) ZSH_THEME_NAME="agnoster" ;;
        3) ZSH_THEME_NAME="powerlevel10k" ;;
    esac
    
    echo
    
    # Auto-update preferences
    if ask_yes_no "Enable automatic dotfiles updates?" "y"; then
        AUTO_UPDATE_DOTFILES="true"
        AUTO_UPDATE_INTERVAL=$(ask_input "Update check interval (days)" "7")
    else
        AUTO_UPDATE_DOTFILES="false"
        AUTO_UPDATE_INTERVAL="0"
    fi
    
    echo
    
    # Set zsh as default
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        if ask_yes_no "Set zsh as your default shell?" "y"; then
            SET_ZSH_DEFAULT="true"
        else
            SET_ZSH_DEFAULT="false"
        fi
    else
        SET_ZSH_DEFAULT="false"
        print_success "zsh is already your default shell"
    fi
    
    print_success "Shell preferences configured"
}

stage_development_tools() {
    print_section "Development Tools"
    
    print_info "Choose which development tools to install."
    echo
    
    # tmux (required for workspace manager)
    if ! command -v tmux &>/dev/null; then
        if ask_yes_no "Install tmux? (required for workspace manager)" "y"; then
            INSTALL_TMUX="true"
        else
            INSTALL_TMUX="false"
            print_warning "Tmux workspace manager will be disabled"
        fi
    else
        INSTALL_TMUX="false"
        print_success "tmux already installed"
    fi
    
    echo
    
    # fzf (required for fuzzy search)
    if ! command -v fzf &>/dev/null; then
        if ask_yes_no "Install fzf? (fuzzy finder - required for sshf/twf)" "y"; then
            INSTALL_FZF="true"
        else
            INSTALL_FZF="false"
            print_warning "Fuzzy search features (sshf, twf) will be disabled"
        fi
    else
        INSTALL_FZF="false"
        print_success "fzf already installed"
    fi
    
    echo
    
    # bat
    if ! command -v bat &>/dev/null && ! command -v batcat &>/dev/null; then
        if ask_yes_no "Install bat? (better cat with syntax highlighting)" "y"; then
            INSTALL_BAT="true"
        else
            INSTALL_BAT="false"
        fi
    else
        INSTALL_BAT="false"
        print_success "bat already installed"
    fi
    
    echo
    
    # eza
    if ! command -v eza &>/dev/null; then
        if ask_yes_no "Install eza? (better ls with colors and icons)" "y"; then
            INSTALL_EZA="true"
        else
            INSTALL_EZA="false"
        fi
    else
        INSTALL_EZA="false"
        print_success "eza already installed"
    fi
    
    echo
    
    # espanso
    if ! command -v espanso &>/dev/null; then
        if ask_yes_no "Install espanso? (text expander)" "y"; then
            INSTALL_ESPANSO="true"
        else
            INSTALL_ESPANSO="false"
        fi
    else
        INSTALL_ESPANSO="false"
        print_success "espanso already installed"
    fi
    
    print_success "Development tools configured"
}

stage_optional_features() {
    print_section "Optional Features"
    
    print_info "Select which optional features to enable."
    print_info "You can always enable/disable these later in dotfiles.conf"
    echo
    
    print_step "Core Features (always enabled):"
    echo "  ${GREEN}✓${NC} SSH Manager - Manage SSH connections with tmux integration"
    echo "  ${GREEN}✓${NC} Tmux Workspaces - Create and manage tmux workspace sessions"
    echo "  ${GREEN}✓${NC} Python Templates - Quick-start Python projects with templates"
    echo "  ${GREEN}✓${NC} MOTD - Custom message of the day with system info"
    echo
    
    print_step "Optional Features:"
    echo
    
    # Command Palette
    print_info "${CYAN}Command Palette${NC} - Fuzzy command launcher (Ctrl+Space)"
    echo "  • Search aliases, functions, history, git/docker commands"
    echo "  • Quick actions and bookmarks"
    echo "  • Requires: fzf"
    if ask_yes_no "Enable Command Palette?" "y"; then
        ENABLE_COMMAND_PALETTE="true"
    else
        ENABLE_COMMAND_PALETTE="false"
    fi
    echo
    
    # Password Manager
    print_info "${CYAN}Password Manager Integration${NC} - Unified CLI for 1Password/LastPass/Bitwarden"
    echo "  • Commands: pw get, pw otp, pw search, pw copy"
    echo "  • Auto-detects installed password manager"
    echo "  • Requires: op, lpass, or bw CLI"
    if ask_yes_no "Enable Password Manager Integration?" "y"; then
        ENABLE_PASSWORD_MANAGER="true"
    else
        ENABLE_PASSWORD_MANAGER="false"
    fi
    echo
    
    # Smart Suggest
    print_info "${CYAN}Smart Suggest${NC} - Intelligent command suggestions and typo correction"
    echo "  • Auto-correct common typos (gti → git, dokcer → docker)"
    echo "  • Suggest package installation for missing commands"
    echo "  • Track frequently used commands and suggest aliases"
    if ask_yes_no "Enable Smart Suggest?" "y"; then
        ENABLE_SMART_SUGGEST="true"
    else
        ENABLE_SMART_SUGGEST="false"
    fi
    
    print_success "Optional features configured"
}

stage_password_managers() {
    print_section "Password Manager CLI Tools (Optional)"
    
    print_info "Install CLI tools for password managers?"
    print_info "These integrate with the vault command for secrets management."
    echo
    
    # 1Password
    if ! command -v op &>/dev/null; then
        if ask_yes_no "Install 1Password CLI (op)?" "n"; then
            INSTALL_1PASSWORD="true"
        else
            INSTALL_1PASSWORD="false"
        fi
    else
        INSTALL_1PASSWORD="false"
        print_success "1Password CLI already installed"
    fi
    
    echo
    
    # LastPass
    if ! command -v lpass &>/dev/null; then
        if ask_yes_no "Install LastPass CLI (lpass)?" "n"; then
            INSTALL_LASTPASS="true"
        else
            INSTALL_LASTPASS="false"
        fi
    else
        INSTALL_LASTPASS="false"
        print_success "LastPass CLI already installed"
    fi
    
    echo
    
    # Bitwarden
    if ! command -v bw &>/dev/null; then
        if ask_yes_no "Install Bitwarden CLI (bw)?" "n"; then
            INSTALL_BITWARDEN="true"
        else
            INSTALL_BITWARDEN="false"
        fi
    else
        INSTALL_BITWARDEN="false"
        print_success "Bitwarden CLI already installed"
    fi
    
    print_success "Password manager setup complete"
}

stage_python_config() {
    print_section "Python Development Setup"
    
    print_info "Configure Python project templates."
    echo
    
    # Base directory for projects
    PY_TEMPLATE_BASE_DIR=$(ask_input "Base directory for Python projects" "${HOME}/projects")
    
    # Default Python version
    PY_TEMPLATE_PYTHON=$(ask_input "Default Python interpreter" "python3")
    
    # Use Poetry
    if ask_yes_no "Use Poetry for dependency management (instead of pip)?" "n"; then
        PY_TEMPLATE_USE_POETRY="true"
    else
        PY_TEMPLATE_USE_POETRY="false"
    fi
    
    # Auto git init
    if ask_yes_no "Automatically initialize git repos for new projects?" "y"; then
        PY_TEMPLATE_GIT_INIT="true"
    else
        PY_TEMPLATE_GIT_INIT="false"
    fi
    
    print_success "Python configuration complete"
}

stage_ssh_setup() {
    print_section "SSH Connection Manager"
    
    print_info "The SSH manager helps you save and quickly connect to servers."
    print_info "It can automatically create tmux sessions on remote hosts."
    echo
    
    if ask_yes_no "Would you like to set up SSH connections now?" "y"; then
        SSH_AUTO_TMUX="true"
        
        echo
        print_step "Let's add some SSH connections!"
        echo
        
        SSH_CONNECTIONS=()
        
        while true; do
            echo
            local name=$(ask_input "Connection name (e.g., 'prod', 'staging')" "")
            
            if [[ -z "$name" ]]; then
                break
            fi
            
            local user=$(ask_input "Username" "$USER")
            local host=$(ask_input "Hostname or IP" "")
            local port=$(ask_input "Port" "22")
            local key_file=$(ask_input "SSH key file (optional)" "")
            local description=$(ask_input "Description (optional)" "")
            
            # Format: name|user@host|port|key_file|options|description
            SSH_CONNECTIONS+=("$name|$user@$host|$port|$key_file||$description")
            
            print_success "Added: $name ($user@$host:$port)"
            echo
            
            if ! ask_yes_no "Add another SSH connection?" "n"; then
                break
            fi
        done
        
        if [[ ${#SSH_CONNECTIONS[@]} -gt 0 ]]; then
            print_success "Added ${#SSH_CONNECTIONS[@]} SSH connection(s)"
        else
            print_info "No SSH connections added (you can add them later with 'ssh-save')"
        fi
    else
        SSH_AUTO_TMUX="true"
        SSH_CONNECTIONS=()
        print_info "Skipping SSH setup (you can configure later with 'ssh-save')"
    fi
}

stage_tmux_workspaces() {
    print_section "Tmux Workspace Manager"
    
    print_info "Create tmux workspaces for your projects."
    print_info "Workspaces save your window/pane layouts per project."
    echo
    
    # Default template
    print_step "Choose your default workspace template:"
    echo "  ${GREEN}1.${NC} dev - 3-pane: editor (50%), terminal (25%), logs (25%)"
    echo "  ${GREEN}2.${NC} ops - 4-pane grid for monitoring"
    echo "  ${GREEN}3.${NC} full - Single full-screen pane"
    echo "  ${GREEN}4.${NC} debug - 2-pane: main (70%), helper (30%)"
    
    local tmux_choice=$(ask_choice "Choose default template" "dev" "ops" "full" "debug")
    case "$tmux_choice" in
        0) TW_DEFAULT_TEMPLATE="dev" ;;
        1) TW_DEFAULT_TEMPLATE="ops" ;;
        2) TW_DEFAULT_TEMPLATE="full" ;;
        3) TW_DEFAULT_TEMPLATE="debug" ;;
    esac
    
    echo
    
    if ask_yes_no "Would you like to create some initial workspaces?" "y"; then
        echo
        print_step "Let's create some workspaces!"
        echo
        
        TMUX_WORKSPACES=()
        
        while true; do
            echo
            local ws_name=$(ask_input "Workspace name (e.g., 'myproject')" "")
            
            if [[ -z "$ws_name" ]]; then
                break
            fi
            
            print_step "Choose template for '$ws_name':"
            echo "  ${GREEN}1.${NC} dev"
            echo "  ${GREEN}2.${NC} ops"
            echo "  ${GREEN}3.${NC} full"
            echo "  ${GREEN}4.${NC} debug"
            
            local ws_template_choice=$(ask_choice "Template" "dev" "ops" "full" "debug")
            local ws_template
            case "$ws_template_choice" in
                0) ws_template="dev" ;;
                1) ws_template="ops" ;;
                2) ws_template="full" ;;
                3) ws_template="debug" ;;
            esac
            
            TMUX_WORKSPACES+=("$ws_name|$ws_template")
            
            print_success "Workspace '$ws_name' will be created with '$ws_template' template"
            echo
            
            if ! ask_yes_no "Create another workspace?" "n"; then
                break
            fi
        done
        
        if [[ ${#TMUX_WORKSPACES[@]} -gt 0 ]]; then
            print_success "Will create ${#TMUX_WORKSPACES[@]} workspace(s)"
        fi
    else
        TMUX_WORKSPACES=()
        print_info "Skipping workspace creation (you can create them later with 'tw-create')"
    fi
}

stage_feature_toggles() {
    print_section "Feature Toggles"
    
    print_info "Enable/disable specific features."
    echo
    
    if ask_yes_no "Enable shell command analytics? (tracks command usage for dfstats)" "y"; then
        ENABLE_ANALYTICS="true"
    else
        ENABLE_ANALYTICS="false"
    fi
    
    echo
    
    if ask_yes_no "Enable ZSH plugins? (autosuggestions, syntax highlighting)" "y"; then
        INSTALL_ZSH_PLUGINS="true"
    else
        INSTALL_ZSH_PLUGINS="false"
    fi
    
    echo
    
    if ask_yes_no "Compile ZSH functions for better performance?" "y"; then
        AUTO_COMPILE_ZSH="true"
    else
        AUTO_COMPILE_ZSH="false"
    fi
    
    print_success "Feature toggles configured"
}

stage_summary() {
    print_section "Configuration Summary"
    
    cat << EOF
Here's what we'll set up:

${CYAN}Personal Information:${NC}
  Name:  $USER_FULLNAME
  Email: $USER_EMAIL

${CYAN}Git Configuration:${NC}
  Default branch: $GIT_DEFAULT_BRANCH
  Credential helper: $GIT_CREDENTIAL_HELPER

${CYAN}Shell:${NC}
  Theme: $ZSH_THEME_NAME
  Set as default: $SET_ZSH_DEFAULT
  Auto-update: $AUTO_UPDATE_DOTFILES

${CYAN}Tools to Install:${NC}
  tmux: ${INSTALL_TMUX:-already installed}
  fzf: ${INSTALL_FZF:-already installed}
  bat: ${INSTALL_BAT:-already installed}
  eza: ${INSTALL_EZA:-already installed}
  espanso: ${INSTALL_ESPANSO:-already installed}
  1Password CLI: ${INSTALL_1PASSWORD:-no}
  LastPass CLI: ${INSTALL_LASTPASS:-no}
  Bitwarden CLI: ${INSTALL_BITWARDEN:-no}

${CYAN}Python Development:${NC}
  Project directory: $PY_TEMPLATE_BASE_DIR
  Python interpreter: $PY_TEMPLATE_PYTHON
  Use Poetry: $PY_TEMPLATE_USE_POETRY
  Auto git init: $PY_TEMPLATE_GIT_INIT

${CYAN}SSH Connections:${NC}
  Auto-tmux on connect: $SSH_AUTO_TMUX
  Connections: ${#SSH_CONNECTIONS[@]}

${CYAN}Tmux Workspaces:${NC}
  Default template: $TW_DEFAULT_TEMPLATE
  Initial workspaces: ${#TMUX_WORKSPACES[@]}

${CYAN}Features:${NC}
  Analytics: $ENABLE_ANALYTICS
  ZSH plugins: $INSTALL_ZSH_PLUGINS
  Auto-compile: $AUTO_COMPILE_ZSH

EOF

    press_enter
}

# ============================================================================
# Save Configuration
# ============================================================================

save_configuration() {
    print_section "Saving Configuration"
    
    print_step "Writing dotfiles.conf..."
    
    cat > "$CONFIG_FILE" << EOF
# ============================================================================
# ADLee's Dotfiles Configuration
# ============================================================================
# Generated by setup wizard on $(date)
# Edit this file to customize your dotfiles installation
# ============================================================================

# Version
DOTFILES_VERSION="1.2.0"

# Repository settings
DOTFILES_GITHUB_USER="${DOTFILES_GITHUB_USER:-adlee-was-taken}"
DOTFILES_REPO_NAME="${DOTFILES_REPO_NAME:-dotfiles}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"
DOTFILES_DIR="\${HOME}/.dotfiles"
DOTFILES_BACKUP_PREFIX="\${HOME}/.dotfiles_backup"

# Personal information
USER_FULLNAME="$USER_FULLNAME"
USER_EMAIL="$USER_EMAIL"

# Git configuration
GIT_USER_NAME="$GIT_USER_NAME"
GIT_USER_EMAIL="$GIT_USER_EMAIL"
GIT_DEFAULT_BRANCH="$GIT_DEFAULT_BRANCH"
GIT_CREDENTIAL_HELPER="$GIT_CREDENTIAL_HELPER"

# Shell preferences
ZSH_THEME_NAME="$ZSH_THEME_NAME"
SET_ZSH_DEFAULT="$SET_ZSH_DEFAULT"

# Installation preferences
INSTALL_DEPS="auto"
INSTALL_ZSH_PLUGINS="$INSTALL_ZSH_PLUGINS"
INSTALL_TMUX="${INSTALL_TMUX:-ask}"
INSTALL_FZF="${INSTALL_FZF:-ask}"
INSTALL_BAT="${INSTALL_BAT:-ask}"
INSTALL_EZA="${INSTALL_EZA:-ask}"
INSTALL_ESPANSO="${INSTALL_ESPANSO:-ask}"
INSTALL_1PASSWORD="${INSTALL_1PASSWORD:-false}"
INSTALL_LASTPASS="${INSTALL_LASTPASS:-false}"
INSTALL_BITWARDEN="${INSTALL_BITWARDEN:-false}"

# Auto-update settings
AUTO_UPDATE_DOTFILES="$AUTO_UPDATE_DOTFILES"
AUTO_UPDATE_INTERVAL="${AUTO_UPDATE_INTERVAL:-7}"

# Python project templates
PY_TEMPLATE_BASE_DIR="$PY_TEMPLATE_BASE_DIR"
PY_TEMPLATE_PYTHON="$PY_TEMPLATE_PYTHON"
PY_TEMPLATE_VENV_NAME="venv"
PY_TEMPLATE_USE_POETRY="$PY_TEMPLATE_USE_POETRY"
PY_TEMPLATE_GIT_INIT="$PY_TEMPLATE_GIT_INIT"

# SSH Manager
SSH_AUTO_TMUX="$SSH_AUTO_TMUX"
SSH_TMUX_SESSION_PREFIX="ssh-"
SSH_SYNC_DOTFILES="false"

# Tmux Workspace Manager
TW_SESSION_PREFIX="work-"
TW_DEFAULT_TEMPLATE="$TW_DEFAULT_TEMPLATE"

# Feature toggles
ENABLE_ANALYTICS="$ENABLE_ANALYTICS"
AUTO_COMPILE_ZSH="$AUTO_COMPILE_ZSH"

# Optional features
ENABLE_COMMAND_PALETTE="$ENABLE_COMMAND_PALETTE"
ENABLE_PASSWORD_MANAGER="$ENABLE_PASSWORD_MANAGER"
ENABLE_SMART_SUGGEST="$ENABLE_SMART_SUGGEST"

# Performance
DEFER_LOAD_FUNCTIONS="true"

EOF

    print_success "Configuration saved to: $CONFIG_FILE"
    
    # Save SSH connections if any
    if [[ ${#SSH_CONNECTIONS[@]} -gt 0 ]]; then
        print_step "Saving SSH connections..."
        
        local ssh_profiles_file="$DOTFILES_DIR/.ssh-profiles"
        mkdir -p "$(dirname "$ssh_profiles_file")"
        
        for connection in "${SSH_CONNECTIONS[@]}"; do
            echo "$connection" >> "$ssh_profiles_file"
        done
        
        print_success "Saved ${#SSH_CONNECTIONS[@]} SSH connection(s)"
    fi
}

# ============================================================================
# Create Resources
# ============================================================================

create_tmux_workspaces() {
    if [[ ${#TMUX_WORKSPACES[@]} -eq 0 ]]; then
        return 0
    fi
    
    print_section "Creating Tmux Workspaces"
    
    for workspace in "${TMUX_WORKSPACES[@]}"; do
        IFS='|' read -r ws_name ws_template <<< "$workspace"
        print_step "Creating workspace: $ws_name (template: $ws_template)"
        
        # Note: We'll create these after installation is complete
        echo "$ws_name|$ws_template" >> "$DOTFILES_DIR/.tmux-workspaces-to-create"
    done
    
    print_success "Workspace creation queued (will be created after installation)"
}

# ============================================================================
# Final Steps
# ============================================================================

stage_completion() {
    print_section "Setup Complete! 🎉"
    
    cat << EOF
${GREEN}✓${NC} Configuration saved
${GREEN}✓${NC} SSH connections saved
${GREEN}✓${NC} Workspace creation queued

${CYAN}Next Steps:${NC}

1. Run the installation script:
   ${YELLOW}cd $DOTFILES_DIR && ./install.sh${NC}

2. Or if you've already run install.sh, reload your shell:
   ${YELLOW}exec zsh${NC}

3. Try out your new features:
   ${YELLOW}# SSH Manager
   ssh-connect <name>     # Connect to saved SSH host
   sshf                   # Fuzzy search connections
   
   # Tmux Workspaces
   tw myproject           # Create/attach workspace
   twf                    # Fuzzy search workspaces
   
   # Python Templates
   py-new myapp           # Create Python project
   py-django myblog       # Create Django project
   
   # Dotfiles Management
   dfd                    # Health check
   dfu                    # Update dotfiles
   dfstats                # View command analytics${NC}

${CYAN}Documentation:${NC}
  • SSH & Tmux Guide: $DOTFILES_DIR/SSH_TMUX_INTEGRATION.md
  • Changelog: $DOTFILES_DIR/CHANGELOG_v1.2.0.md
  • README: $DOTFILES_DIR/README.md

${CYAN}Useful Resources:${NC}
  • GitHub Repo: https://github.com/${DOTFILES_GITHUB_USER:-adlee-was-taken}/${DOTFILES_REPO_NAME:-dotfiles}
  • Report Issues: https://github.com/${DOTFILES_GITHUB_USER:-adlee-was-taken}/${DOTFILES_REPO_NAME:-dotfiles}/issues

EOF

    print_success "Happy coding! 🚀"
    echo
}

# ============================================================================
# Main Wizard Flow
# ============================================================================

main() {
    stage_welcome
    stage_personal_info
    stage_git_config
    stage_shell_preferences
    stage_development_tools
    stage_optional_features
    stage_password_managers
    stage_python_config
    stage_ssh_setup
    stage_tmux_workspaces
    stage_feature_toggles
    stage_summary
    
    if ask_yes_no "Save this configuration and continue?" "y"; then
        save_configuration
        create_tmux_workspaces
        stage_completion
        
        echo
        if ask_yes_no "Run installation now?" "y"; then
            exec "$DOTFILES_DIR/install.sh"
        fi
    else
        echo
        print_warning "Configuration not saved. Run this wizard again when ready!"
        exit 0
    fi
}

main "$@"
