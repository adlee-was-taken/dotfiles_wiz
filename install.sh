#!/usr/bin/env bash
# ============================================================================
# dotfiles_wiz - Universal Dotfiles Installer
# ============================================================================
# A standalone dotfiles management framework that works in two modes:
#
# Mode 1: Use bundled dotfiles (included starter pack)
# Mode 2: Use your own dotfiles repository
#
# Usage:
#   ./install.sh                    # Interactive mode (asks about repo)
#   ./install.sh --local            # Use bundled dotfiles
#   ./install.sh --repo <url>       # Use specific repository
#   ./install.sh --wizard           # Full setup wizard
# ============================================================================

set -e

# ============================================================================
# Configuration
# ============================================================================

INSTALLER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${HOME}/.dotfiles"
DOTFILES_BACKUP_PREFIX="${HOME}/.dotfiles_backup"
USE_BUNDLED_DOTFILES=""
CUSTOM_REPO_URL=""
SKIP_DEPS=false
DEPS_ONLY=false
UNINSTALL=false
UNINSTALL_PURGE=false
RUN_WIZARD=false

# ============================================================================
# Parse Arguments
# ============================================================================

while [[ $# -gt 0 ]]; do
    case "$1" in
        --local)
            USE_BUNDLED_DOTFILES=true
            shift
            ;;
        --repo)
            shift
            CUSTOM_REPO_URL="$1"
            USE_BUNDLED_DOTFILES=false
            shift
            ;;
        --wizard)
            RUN_WIZARD=true
            shift
            ;;
        --skip-deps)
            SKIP_DEPS=true
            shift
            ;;
        --deps-only)
            DEPS_ONLY=true
            shift
            ;;
        --uninstall)
            UNINSTALL=true
            shift
            ;;
        --purge)
            UNINSTALL_PURGE=true
            shift
            ;;
        --help|-h)
            cat << 'EOF'
dotfiles_wiz - Universal Dotfiles Installer

Usage: ./install.sh [OPTIONS]

Installation Modes:
  (no args)          Interactive mode - asks about existing repo
  --local            Use bundled dotfiles (included starter pack)
  --repo <url>       Use specific git repository
  --wizard           Full interactive setup wizard

Options:
  --skip-deps        Skip dependency installation
  --deps-only        Only install dependencies, then exit
  --uninstall        Remove dotfiles and restore backups
  --purge            With --uninstall, also remove ~/.dotfiles
  --help             Show this help

Examples:
  # Interactive (recommended for first time)
  ./install.sh

  # Use bundled dotfiles
  ./install.sh --local

  # Use your own repo
  ./install.sh --repo https://github.com/you/dotfiles.git

  # Full setup wizard
  ./install.sh --wizard

Features Included:
  ✨ SSH session manager with auto-tmux
  ✨ Tmux workspace manager with templates
  ✨ Python project templates (Django, Flask, FastAPI, etc.)
  ✨ Command analytics
  ✨ Secrets management
  ✨ Custom MOTD
  ✨ And more!

Documentation:
  README.md                - Complete features guide
  QUICKSTART.md            - 5-minute getting started
  INSTALLATION_GUIDE.md    - Detailed installation
  SSH_TMUX_INTEGRATION.md  - Advanced workflows

EOF
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Run with --help for usage"
            exit 1
            ;;
    esac
done

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
# Helper Functions
# ============================================================================

print_header() {
    clear
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ${CYAN}✨ dotfiles_wiz - Universal Dotfiles Installer ✨${NC}        ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}                                                            ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  Two modes. One installer. Infinite possibilities.        ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"
}

print_step() {
    echo -e "${GREEN}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

ask_yes_no() {
    local prompt="$1"
    local default="${2:-y}"

    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    read -p "$(echo -e "${CYAN}?${NC} $prompt")" response
    response=${response:-$default}
    [[ "$response" =~ ^[Yy]$ ]]
}

# ============================================================================
# Mode Selection
# ============================================================================

select_dotfiles_mode() {
    # If already specified via command line, skip
    if [[ -n "$CUSTOM_REPO_URL" ]]; then
        print_success "Using custom repository: $CUSTOM_REPO_URL"
        return 0
    fi

    if [[ "$USE_BUNDLED_DOTFILES" == "true" ]]; then
        print_success "Using bundled dotfiles"
        return 0
    fi

    # Interactive mode selection
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  Dotfiles Source Selection                                ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}\n"

    cat << 'EOF'
This installer can work with dotfiles in two ways:

┌─────────────────────────────────────────────────────────────┐
│ Option 1: Use Your Own Dotfiles Repository                 │
└─────────────────────────────────────────────────────────────┘
  → You already have a dotfiles repo on GitHub/GitLab
  → Installer will clone and manage it
  → Recommended if you're migrating from another setup

┌─────────────────────────────────────────────────────────────┐
│ Option 2: Use Bundled Dotfiles (Starter Pack)              │
└─────────────────────────────────────────────────────────────┘
  → Uses the included, ready-to-use dotfiles
  → Includes: SSH manager, tmux workspaces, Python templates
  → Perfect for first-time users
  → Can be customized after installation
  → Can be pushed to your own GitHub repo later

EOF

    if ask_yes_no "Do you have an existing dotfiles repository?" "n"; then
        echo
        read -p "$(echo -e "${CYAN}?${NC} Enter your dotfiles repository URL: ")" CUSTOM_REPO_URL

        if [[ -z "$CUSTOM_REPO_URL" ]]; then
            print_warning "No URL provided, using bundled dotfiles instead"
            USE_BUNDLED_DOTFILES=true
        else
            print_success "Will use: $CUSTOM_REPO_URL"
            USE_BUNDLED_DOTFILES=false
        fi
    else
        print_success "Using bundled dotfiles"
        USE_BUNDLED_DOTFILES=true
    fi

    echo
}

# ============================================================================
# OS Detection
# ============================================================================

detect_os() {
    print_step "Detecting operating system"

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
            OS_VERSION=$VERSION_ID
        fi
        print_success "Detected: Linux ($OS)"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_success "Detected: macOS"
    else
        OS="unknown"
        print_warning "Unknown OS: $OSTYPE"
    fi
}

# ============================================================================
# Dotfiles Setup
# ============================================================================

setup_dotfiles() {
    print_step "Setting up dotfiles"

    if [[ "$USE_BUNDLED_DOTFILES" == "true" ]]; then
        # Copy bundled dotfiles from installer directory
        if [ -d "$INSTALLER_DIR/dotfiles" ]; then
            print_step "Copying bundled dotfiles to $DOTFILES_DIR"

            if [ -d "$DOTFILES_DIR" ]; then
                print_warning "Dotfiles directory already exists at $DOTFILES_DIR"
                if ask_yes_no "Overwrite existing dotfiles?" "n"; then
                    mv "$DOTFILES_DIR" "${DOTFILES_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
                    print_success "Backed up existing dotfiles"
                else
                    print_error "Installation cancelled"
                    exit 1
                fi
            fi

            cp -r "$INSTALLER_DIR/dotfiles" "$DOTFILES_DIR"

            # Initialize as git repo
            cd "$DOTFILES_DIR"
            if [ ! -d ".git" ]; then
                git init
                git add .
                git commit -m "Initial dotfiles setup from dotfiles_wiz

Includes:
- SSH session manager
- Tmux workspace manager
- Python project templates
- Command analytics
- Secrets management
- Custom MOTD
"
                print_success "Initialized git repository"
            fi

            print_success "Bundled dotfiles installed to $DOTFILES_DIR"
            echo
            print_info "You can later push to your own GitHub repo with:"
            echo "  cd $DOTFILES_DIR"
            echo "  git remote add origin https://github.com/you/dotfiles.git"
            echo "  git push -u origin main"
            echo
        else
            print_error "Bundled dotfiles not found at $INSTALLER_DIR/dotfiles"
            echo "This installer package may be incomplete."
            exit 1
        fi
    else
        # Clone from custom repository
        if [ -d "$DOTFILES_DIR" ]; then
            print_warning "Dotfiles directory already exists at $DOTFILES_DIR"
            if ask_yes_no "Update existing dotfiles from repository?" "y"; then
                cd "$DOTFILES_DIR"
                git pull
                print_success "Dotfiles updated"
            fi
        else
            print_step "Cloning from repository: $CUSTOM_REPO_URL"
            git clone "$CUSTOM_REPO_URL" "$DOTFILES_DIR"
            print_success "Dotfiles cloned from repository"
        fi
    fi

    # Verify dotfiles structure
    if [[ ! -f "$DOTFILES_DIR/zsh/.zshrc" ]]; then
        print_warning "Standard .zshrc not found at zsh/.zshrc"
        echo "Your dotfiles may have a different structure."
        echo "Expected structure:"
        echo "  ~/.dotfiles/zsh/.zshrc"
        echo "  ~/.dotfiles/git/.gitconfig"
        echo "  ~/.dotfiles/vim/.vimrc"
        echo
        if ! ask_yes_no "Continue anyway?" "y"; then
            exit 1
        fi
    fi

    print_success "Dotfiles ready at: $DOTFILES_DIR"
}

# ============================================================================
# Feature Detection
# ============================================================================

detect_features() {
    print_step "Detecting available features"

    FEATURES_FOUND=()

    # Check for SSH manager
    if [[ -f "$DOTFILES_DIR/zsh/functions/ssh-manager.zsh" ]]; then
        FEATURES_FOUND+=("SSH Session Manager")
    fi

    # Check for tmux workspaces
    if [[ -f "$DOTFILES_DIR/zsh/functions/tmux-workspaces.zsh" ]]; then
        FEATURES_FOUND+=("Tmux Workspace Manager")
    fi

    # Check for Python templates
    if [[ -f "$DOTFILES_DIR/zsh/functions/python-templates.zsh" ]]; then
        FEATURES_FOUND+=("Python Project Templates")
    fi

    # Check for analytics
    if [[ -f "$DOTFILES_DIR/zsh/functions/analytics.zsh" ]]; then
        FEATURES_FOUND+=("Command Analytics")
    fi

    # Check for vault
    if [[ -f "$DOTFILES_DIR/zsh/functions/vault.zsh" ]]; then
        FEATURES_FOUND+=("Secrets Management")
    fi

    # Check for MOTD
    if [[ -f "$DOTFILES_DIR/zsh/functions/motd.zsh" ]]; then
        FEATURES_FOUND+=("Custom MOTD")
    fi

    if [[ ${#FEATURES_FOUND[@]} -gt 0 ]]; then
        echo
        echo -e "${CYAN}Available Features:${NC}"
        for feature in "${FEATURES_FOUND[@]}"; do
            echo -e "  ${GREEN}✓${NC} $feature"
        done
        echo
    else
        print_warning "No additional features detected (basic dotfiles only)"
    fi
}

# ============================================================================
# Dependencies
# ============================================================================

check_core_deps() {
    command -v git &>/dev/null && command -v curl &>/dev/null && command -v zsh &>/dev/null
}

install_dependencies() {
    if [[ "$SKIP_DEPS" == true ]]; then
        print_step "Skipping dependencies (--skip-deps)"
        return 0
    fi

    if check_core_deps; then
        print_step "Dependencies check"
        print_success "Core dependencies already installed (git, curl, zsh)"
        return 0
    fi

    print_step "Installing dependencies"

    case "$OS" in
        ubuntu|debian)
            sudo apt-get update
            sudo apt-get install -y git curl zsh
            ;;
        fedora|rhel|centos)
            sudo dnf install -y git curl zsh
            ;;
        arch|cachyos)
            sudo pacman -Sy --noconfirm git curl zsh
            ;;
        macos)
            if ! command -v brew &> /dev/null; then
                print_warning "Homebrew not found. Installing..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install git curl zsh
            ;;
        *)
            print_warning "Please install git, curl, and zsh manually"
            ;;
    esac

    print_success "Dependencies installed"
}

# ============================================================================
# Configuration & Linking
# ============================================================================

backup_existing_configs() {
    print_step "Backing up existing configurations"

    local files_to_backup=(
        ".zshrc"
        ".bashrc"
        ".gitconfig"
        ".vimrc"
        ".tmux.conf"
    )

    local backup_needed=false
    BACKUP_DIR="${DOTFILES_BACKUP_PREFIX}_$(date +%Y%m%d_%H%M%S)"

    for file in "${files_to_backup[@]}"; do
        if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            if [ "$backup_needed" = false ]; then
                mkdir -p "$BACKUP_DIR"
                backup_needed=true
            fi
            cp "$HOME/$file" "$BACKUP_DIR/"
            print_success "Backed up: $file"
        fi
    done

    if [ "$backup_needed" = true ]; then
        print_success "Backups saved to: $BACKUP_DIR"
    else
        print_success "No backups needed"
    fi
}

install_oh_my_zsh() {
    print_step "Checking oh-my-zsh"

    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_success "oh-my-zsh already installed"
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "oh-my-zsh installed"
    fi
}

link_dotfiles() {
    print_step "Linking dotfiles"

    # Link zshrc and adlee theme.
    if [ -f "$DOTFILES_DIR/zsh/themes/adlee.zsh-theme" ]; then
        ln -sf "$DOTFILES_DIR/zsh/themes/adlee.zsh-theme" "$HOME/.oh-my-zsh/themes/adlee.zsh-theme"
        print_success "Linked: adlee.zsh-theme"
    fi

    if [ -f "$DOTFILES_DIR/zsh/.zshrc" ]; then
        ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
        print_success "Linked: .zshrc"
    fi

    # Link gitconfig
    if [ -f "$DOTFILES_DIR/git/.gitconfig" ]; then
        ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
        print_success "Linked: .gitconfig"
    fi

    # Link vimrc
    if [ -f "$DOTFILES_DIR/vim/.vimrc" ]; then
        ln -sf "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
        print_success "Linked: .vimrc"
    fi

    # Link tmux.conf
    if [ -f "$DOTFILES_DIR/tmux/.tmux.conf" ]; then
        ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
        print_success "Linked: .tmux.conf"
    fi

    # Link bin scripts if they exist
    if [ -d "$INSTALLER_DIR/bin" ]; then
        mkdir -p "$HOME/.local/bin"
        for script in "$INSTALLER_DIR/bin"/*; do
            if [ -f "$script" ]; then
                ln -sf "$script" "$HOME/.local/bin/$(basename "$script")"
                chmod +x "$HOME/.local/bin/$(basename "$script")"
            fi
        done
        print_success "Linked: bin scripts"
    fi
}

set_zsh_default() {
    print_step "Checking default shell"

    if [ "$SHELL" != "$(which zsh)" ]; then
        if ask_yes_no "Set zsh as your default shell?" "y"; then
            chsh -s "$(which zsh)"
            print_success "Default shell changed to zsh (restart required)"
        fi
    else
        print_success "zsh is already your default shell"
    fi
}

# ============================================================================
# Uninstall
# ============================================================================

do_uninstall() {
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  Dotfiles Uninstallation                                   ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"

    print_step "Removing symlinks"

    local symlinks=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
        "$HOME/.vimrc"
        "$HOME/.tmux.conf"
    )

    for link in "${symlinks[@]}"; do
        if [[ -L "$link" ]]; then
            rm "$link"
            print_success "Removed: $link"
        fi
    done

    if [[ "$UNINSTALL_PURGE" == true ]]; then
        if [[ -d "$DOTFILES_DIR" ]]; then
            if ask_yes_no "Delete $DOTFILES_DIR?" "n"; then
                rm -rf "$DOTFILES_DIR"
                print_success "Removed: $DOTFILES_DIR"
            fi
        fi
    fi

    print_success "Uninstallation complete!"
    exit 0
}

# ============================================================================
# Main
# ============================================================================

main() {
    # Handle uninstall
    if [[ "$UNINSTALL" == true ]]; then
        do_uninstall
    fi

    # Handle wizard
    if [[ "$RUN_WIZARD" == true ]]; then
        if [[ -f "$INSTALLER_DIR/setup/setup-wizard.sh" ]]; then
            exec bash "$INSTALLER_DIR/setup/setup-wizard.sh"
        else
            print_error "Wizard not found at $INSTALLER_DIR/setup/setup-wizard.sh"
            exit 1
        fi
    fi

    print_header

    # Mode selection (interactive if not specified)
    select_dotfiles_mode

    detect_os

    # Handle deps-only
    if [[ "$DEPS_ONLY" == true ]]; then
        install_dependencies
        print_success "Dependencies installed"
        exit 0
    fi

    # Main installation flow
    if ask_yes_no "Continue with installation?" "y"; then
        install_dependencies
        setup_dotfiles
        detect_features
        backup_existing_configs
        install_oh_my_zsh
        link_dotfiles
        set_zsh_default

        echo
        echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${NC}  ✓ Installation Complete! 🎉                              ${GREEN}║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
        echo
        echo -e "${CYAN}Next Steps:${NC}"
        echo "  1. Reload your shell:  ${YELLOW}exec zsh${NC}"
        echo "  2. Verify installation: ${YELLOW}dfd${NC} (if available)"
        echo

        if [[ ${#FEATURES_FOUND[@]} -gt 0 ]]; then
            echo -e "${CYAN}Try out these features:${NC}"
            for feature in "${FEATURES_FOUND[@]}"; do
                case "$feature" in
                    "SSH Session Manager")
                        echo "  • ${YELLOW}ssh-save prod user@server.com${NC}"
                        echo "  • ${YELLOW}sshf${NC} - Fuzzy search connections"
                        ;;
                    "Tmux Workspace Manager")
                        echo "  • ${YELLOW}tw myproject${NC} - Create/attach workspace"
                        echo "  • ${YELLOW}twf${NC} - Fuzzy search workspaces"
                        ;;
                    "Python Project Templates")
                        echo "  • ${YELLOW}py-new myapp${NC} - Create Python project"
                        echo "  • ${YELLOW}py-django myblog${NC} - Create Django project"
                        ;;
                esac
            done
            echo
        fi

        echo -e "${CYAN}Documentation:${NC}"
        if [[ -f "$DOTFILES_DIR/README.md" ]]; then
            echo "  ${YELLOW}cat ~/.dotfiles/README.md${NC}"
        fi
        if [[ -f "$INSTALLER_DIR/QUICKSTART.md" ]]; then
            echo "  ${YELLOW}cat $INSTALLER_DIR/QUICKSTART.md${NC}"
        fi
        echo
        print_success "Happy coding! 🚀"
        echo
    else
        print_warning "Installation cancelled"
        exit 0
    fi
}

main "$@"
