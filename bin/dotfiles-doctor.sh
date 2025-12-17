#!/usr/bin/env bash
# ============================================================================
# Dotfiles Health Check & Doctor
# ============================================================================
# Diagnoses issues with dotfiles installation and provides fixes
# Usage: dotfiles-doctor.sh [--fix] [--verbose]
# ============================================================================

set -e

# ============================================================================
# Configuration
# ============================================================================

DOTFILES_DIR="${HOME}/.dotfiles"
VERBOSE=false
AUTO_FIX=false
ISSUES_FOUND=0
WARNINGS_FOUND=0

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --fix|-f) AUTO_FIX=true ;;
        --verbose|-v) VERBOSE=true ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "Options:"
            echo "  --fix, -f       Automatically fix issues where possible"
            echo "  --verbose, -v   Show detailed output"
            echo "  --help, -h      Show this help"
            echo
            echo "Checks:"
            echo "  • Core dependencies (git, zsh, curl)"
            echo "  • Dotfiles installation and symlinks"
            echo "  • SSH connection manager setup"
            echo "  • Tmux workspace manager configuration"
            echo "  • Python template system"
            echo "  • Optional tools (fzf, bat, eza, espanso)"
            echo "  • Performance and configuration"
            exit 0
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
NC='\033[0m'

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  Dotfiles Health Check                                     ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"
}

print_section() {
    echo -e "\n${CYAN}▶ $1${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

check_ok() {
    echo -e "${GREEN}✓${NC} $1"
    [[ "$VERBOSE" == true ]] && echo "  └─ $2"
}

check_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    [[ -n "$2" ]] && echo "  └─ $2"
    ((WARNINGS_FOUND++))
}

check_error() {
    echo -e "${RED}✗${NC} $1"
    [[ -n "$2" ]] && echo "  └─ Fix: $2"
    ((ISSUES_FOUND++))
}

check_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ============================================================================
# Check Functions
# ============================================================================

check_core_dependencies() {
    print_section "Core Dependencies"
    
    local deps=("git" "curl" "zsh")
    local all_good=true
    
    for dep in "${deps[@]}"; do
        if command -v "$dep" &>/dev/null; then
            local version=$(${dep} --version 2>&1 | head -n1)
            check_ok "$dep installed" "$version"
        else
            check_error "$dep not found" "Install with: sudo apt install $dep (or brew install $dep)"
            all_good=false
        fi
    done
    
    if [[ "$all_good" == true ]]; then
        check_ok "All core dependencies satisfied"
    fi
}

check_dotfiles_installation() {
    print_section "Dotfiles Installation"
    
    # Check dotfiles directory
    if [[ -d "$DOTFILES_DIR" ]]; then
        check_ok "Dotfiles directory exists" "$DOTFILES_DIR"
    else
        check_error "Dotfiles directory not found" "Clone repo: git clone https://github.com/adlee-was-taken/dotfiles.git ~/.dotfiles"
        return 1
    fi
    
    # Check if it's a git repo
    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        check_ok "Git repository initialized"
        
        # Check for updates
        cd "$DOTFILES_DIR"
        git fetch --quiet 2>/dev/null || true
        local behind=$(git rev-list HEAD..origin/main --count 2>/dev/null || echo "0")
        if [[ "$behind" -gt 0 ]]; then
            check_warning "Dotfiles $behind commit(s) behind origin" "Run: dfu or dfupdate"
        else
            check_ok "Dotfiles up to date"
        fi
    else
        check_warning "Not a git repository" "Dotfiles won't be able to auto-update"
    fi
    
    # Check configuration file
    if [[ -f "$DOTFILES_DIR/dotfiles.conf" ]]; then
        check_ok "Configuration file exists"
    else
        check_warning "Configuration file missing" "Run setup wizard: ./setup/setup-wizard.sh"
    fi
}

check_symlinks() {
    print_section "Symlinks"
    
    local symlinks=(
        "$HOME/.zshrc:$DOTFILES_DIR/zsh/.zshrc"
        "$HOME/.gitconfig:$DOTFILES_DIR/git/.gitconfig"
        "$HOME/.vimrc:$DOTFILES_DIR/vim/.vimrc"
        "$HOME/.tmux.conf:$DOTFILES_DIR/tmux/.tmux.conf"
    )
    
    local all_good=true
    
    for link_pair in "${symlinks[@]}"; do
        IFS=':' read -r link target <<< "$link_pair"
        local filename=$(basename "$link")
        
        if [[ -L "$link" ]]; then
            local actual_target=$(readlink "$link")
            if [[ "$actual_target" == "$target" ]]; then
                check_ok "$filename linked correctly"
            else
                check_warning "$filename linked to wrong target" "Expected: $target, Got: $actual_target"
                all_good=false
            fi
        elif [[ -e "$link" ]]; then
            check_warning "$filename exists but is not a symlink" "Backup and re-run: ./install.sh"
            all_good=false
        else
            check_error "$filename not linked" "Run: ./install.sh"
            all_good=false
        fi
    done
    
    if [[ "$all_good" == true ]]; then
        check_ok "All symlinks configured correctly"
    fi
}

check_shell() {
    print_section "Shell Configuration"
    
    # Check current shell
    if [[ "$SHELL" == *"zsh"* ]]; then
        check_ok "ZSH is default shell" "$SHELL"
    else
        check_warning "ZSH is not default shell" "Run: chsh -s $(which zsh)"
    fi
    
    # Check oh-my-zsh
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        check_ok "oh-my-zsh installed"
    else
        check_error "oh-my-zsh not found" "Run: ./install.sh"
    fi
    
    # Check plugins
    local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    
    if [[ -d "$custom_dir/zsh-autosuggestions" ]]; then
        check_ok "zsh-autosuggestions installed"
    else
        check_warning "zsh-autosuggestions missing" "Enhanced suggestions disabled"
    fi
    
    if [[ -d "$custom_dir/zsh-syntax-highlighting" ]]; then
        check_ok "zsh-syntax-highlighting installed"
    else
        check_warning "zsh-syntax-highlighting missing" "Syntax highlighting disabled"
    fi
}

check_ssh_manager() {
    print_section "SSH Session Manager"
    
    # Check if function is loaded
    if command -v ssh-save &>/dev/null; then
        check_ok "SSH manager functions loaded"
    else
        check_error "SSH manager not loaded" "Source .zshrc: exec zsh"
        return 1
    fi
    
    # Check profiles file
    local profiles_file="$DOTFILES_DIR/.ssh-profiles"
    if [[ -f "$profiles_file" ]]; then
        local count=$(wc -l < "$profiles_file" 2>/dev/null || echo "0")
        if [[ "$count" -gt 0 ]]; then
            check_ok "SSH profiles configured" "$count connection(s) saved"
        else
            check_info "No SSH profiles configured" "Add with: ssh-save <name> <user@host>"
        fi
    else
        check_info "No SSH profiles file" "Create your first: ssh-save <name> <user@host>"
    fi
    
    # Check tmux integration
    if command -v tmux &>/dev/null; then
        check_ok "tmux available for SSH integration"
    else
        check_warning "tmux not installed" "Auto-tmux on SSH disabled. Install: sudo apt install tmux"
    fi
    
    # Check fzf for fuzzy search
    if command -v fzf &>/dev/null; then
        check_ok "fzf available for sshf command"
    else
        check_warning "fzf not installed" "Fuzzy search (sshf) disabled. Install: git clone https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install"
    fi
}

check_tmux_workspaces() {
    print_section "Tmux Workspace Manager"
    
    # Check if functions loaded
    if command -v tw &>/dev/null; then
        check_ok "Tmux workspace functions loaded"
    else
        check_error "Tmux workspace manager not loaded" "Source .zshrc: exec zsh"
        return 1
    fi
    
    # Check tmux installation
    if command -v tmux &>/dev/null; then
        local version=$(tmux -V)
        check_ok "tmux installed" "$version"
    else
        check_error "tmux not installed" "Install: sudo apt install tmux (or brew install tmux)"
        return 1
    fi
    
    # Check template directory
    local template_dir="$DOTFILES_DIR/.tmux-templates"
    if [[ -d "$template_dir" ]]; then
        local count=$(find "$template_dir" -type f -name "*.tmux" 2>/dev/null | wc -l)
        check_ok "Workspace templates available" "$count template(s)"
    else
        check_warning "Template directory missing" "Will be created on first use"
    fi
    
    # Check active workspaces
    if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null; then
        local workspace_count=$(tmux list-sessions 2>/dev/null | grep -c "^work-" || echo "0")
        if [[ "$workspace_count" -gt 0 ]]; then
            check_ok "Active workspaces running" "$workspace_count workspace(s)"
        else
            check_info "No active workspaces" "Create one: tw myproject"
        fi
    fi
    
    # Check fzf for fuzzy search
    if command -v fzf &>/dev/null; then
        check_ok "fzf available for twf command"
    else
        check_warning "fzf not installed" "Fuzzy search (twf) disabled"
    fi
}

check_python_templates() {
    print_section "Python Project Templates"
    
    # Check if functions loaded
    if command -v py-new &>/dev/null; then
        check_ok "Python template functions loaded"
    else
        check_error "Python templates not loaded" "Source .zshrc: exec zsh"
        return 1
    fi
    
    # Check Python installation
    local python_cmd="${PY_TEMPLATE_PYTHON:-python3}"
    if command -v "$python_cmd" &>/dev/null; then
        local version=$($python_cmd --version)
        check_ok "Python installed" "$version"
    else
        check_error "Python not found" "Install Python 3"
        return 1
    fi
    
    # Check venv module
    if $python_cmd -m venv --help &>/dev/null; then
        check_ok "venv module available"
    else
        check_warning "venv module missing" "Install: sudo apt install python3-venv"
    fi
    
    # Check pip
    if $python_cmd -m pip --version &>/dev/null; then
        check_ok "pip available"
    else
        check_warning "pip not found" "Install: sudo apt install python3-pip"
    fi
    
    # Check Poetry (optional)
    if command -v poetry &>/dev/null; then
        check_ok "Poetry installed (optional)"
    else
        check_info "Poetry not installed" "Optional - for advanced dependency management"
    fi
    
    # Check base project directory
    local base_dir="${PY_TEMPLATE_BASE_DIR:-$HOME/projects}"
    if [[ -d "$base_dir" ]]; then
        check_ok "Project base directory exists" "$base_dir"
    else
        check_info "Project base directory will be created" "$base_dir"
    fi
}

check_optional_tools() {
    print_section "Optional Tools"
    
    # fzf
    if command -v fzf &>/dev/null; then
        check_ok "fzf (fuzzy finder)"
    else
        check_info "fzf not installed" "Enables fuzzy search (sshf, twf)"
    fi
    
    # bat
    if command -v bat &>/dev/null || command -v batcat &>/dev/null; then
        check_ok "bat (better cat)"
    else
        check_info "bat not installed" "Syntax highlighting for file viewing"
    fi
    
    # eza
    if command -v eza &>/dev/null; then
        check_ok "eza (better ls)"
    else
        check_info "eza not installed" "Enhanced ls with colors and icons"
    fi
    
    # espanso
    if command -v espanso &>/dev/null; then
        check_ok "espanso (text expander)"
    else
        check_info "espanso not installed" "Text expansion shortcuts disabled"
    fi
    
    # ripgrep
    if command -v rg &>/dev/null; then
        check_ok "ripgrep (fast search)"
    else
        check_info "ripgrep not installed" "Enhanced grep alternative"
    fi
}

check_password_managers() {
    print_section "Password Manager CLIs"
    
    local found_any=false
    
    # 1Password
    if command -v op &>/dev/null; then
        check_ok "1Password CLI (op)"
        found_any=true
    else
        check_info "1Password CLI not installed" "vault 1password commands disabled"
    fi
    
    # LastPass
    if command -v lpass &>/dev/null; then
        check_ok "LastPass CLI (lpass)"
        found_any=true
    else
        check_info "LastPass CLI not installed" "vault lastpass commands disabled"
    fi
    
    # Bitwarden
    if command -v bw &>/dev/null; then
        check_ok "Bitwarden CLI (bw)"
        found_any=true
    else
        check_info "Bitwarden CLI not installed" "vault bitwarden commands disabled"
    fi
    
    if [[ "$found_any" == false ]]; then
        check_info "No password managers detected" "Install for vault command integration"
    fi
}

check_performance() {
    print_section "Performance & Configuration"
    
    # Check compiled zsh functions
    local function_dir="$DOTFILES_DIR/zsh/functions"
    if [[ -d "$function_dir" ]]; then
        local zwc_count=$(find "$function_dir" -name "*.zwc" 2>/dev/null | wc -l)
        if [[ "$zwc_count" -gt 0 ]]; then
            check_ok "ZSH functions compiled" "$zwc_count compiled file(s)"
        else
            check_warning "ZSH functions not compiled" "Run: dfcompile (improves startup time)"
        fi
    fi
    
    # Check analytics
    if [[ -f "$HOME/.shell_analytics" ]]; then
        check_ok "Command analytics enabled"
    else
        check_info "Command analytics disabled" "Enable in dotfiles.conf: ENABLE_ANALYTICS=true"
    fi
    
    # Check deferred loading
    if grep -q "DEFER_LOAD_FUNCTIONS" "$DOTFILES_DIR/dotfiles.conf" 2>/dev/null; then
        check_ok "Deferred function loading enabled" "Faster shell startup"
    else
        check_info "Deferred loading not configured" "Add to dotfiles.conf for faster startup"
    fi
}

check_bin_scripts() {
    print_section "Utility Scripts"
    
    local bin_dir="$HOME/.local/bin"
    
    if [[ -d "$bin_dir" ]]; then
        check_ok "Bin directory exists" "$bin_dir"
        
        local scripts=("dotfiles-doctor.sh" "dotfiles-sync.sh" "dotfiles-update.sh")
        
        for script in "${scripts[@]}"; do
            if [[ -x "$bin_dir/$script" ]]; then
                check_ok "$script available"
            else
                check_warning "$script missing or not executable" "Re-run: ./install.sh"
            fi
        done
    else
        check_warning "Bin directory missing" "Create: mkdir -p ~/.local/bin"
    fi
    
    # Check if bin is in PATH
    if echo "$PATH" | grep -q "$bin_dir"; then
        check_ok "Bin directory in PATH"
    else
        check_warning "Bin directory not in PATH" "Add to .zshrc: export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
}

# ============================================================================
# Summary
# ============================================================================

print_summary() {
    print_section "Summary"
    
    if [[ $ISSUES_FOUND -eq 0 && $WARNINGS_FOUND -eq 0 ]]; then
        echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║${NC}  ✓ All checks passed! Your dotfiles are healthy.          ${GREEN}║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
        echo
        echo -e "${CYAN}Your dotfiles are configured perfectly! 🎉${NC}"
    else
        echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║${NC}  Health Check Complete                                     ${YELLOW}║${NC}"
        echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
        echo
        echo -e "${RED}Issues found: ${ISSUES_FOUND}${NC}"
        echo -e "${YELLOW}Warnings: ${WARNINGS_FOUND}${NC}"
        echo
        
        if [[ $ISSUES_FOUND -gt 0 ]]; then
            echo -e "${CYAN}Quick fixes:${NC}"
            echo "  • Re-run installation: cd ~/.dotfiles && ./install.sh"
            echo "  • Reload shell: exec zsh"
            echo "  • Check docs: cat ~/.dotfiles/README.md"
        fi
        
        if [[ "$AUTO_FIX" == false ]]; then
            echo
            echo -e "${BLUE}ℹ${NC} Run with --fix to automatically fix some issues"
        fi
    fi
    
    echo
    echo -e "${CYAN}Useful commands:${NC}"
    echo "  dfd / doctor      - This health check"
    echo "  dfu / dfupdate    - Update dotfiles"
    echo "  dfs / dfsync      - Sync to GitHub"
    echo "  dfstats           - Command analytics"
    echo "  dfcompile         - Compile ZSH functions"
    echo
}

# ============================================================================
# Main
# ============================================================================

main() {
    print_header
    
    check_core_dependencies
    check_dotfiles_installation
    check_symlinks
    check_shell
    check_ssh_manager
    check_tmux_workspaces
    check_python_templates
    check_optional_tools
    check_password_managers
    check_performance
    check_bin_scripts
    
    print_summary
    
    # Exit with error if issues found
    [[ $ISSUES_FOUND -eq 0 ]] && exit 0 || exit 1
}

main "$@"
