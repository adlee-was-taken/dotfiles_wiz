# Complete Installation Guide - Dotfiles v1.2.0

## 📋 Table of Contents

1. [Installation Methods](#installation-methods)
2. [Step-by-Step Setup](#step-by-step-setup)
3. [Feature Configuration](#feature-configuration)
4. [Post-Installation](#post-installation)
5. [Verification](#verification)
6. [Troubleshooting](#troubleshooting)

---

## Installation Methods

### Method 1: Interactive Wizard (Recommended)

The wizard guides you through every option:

```bash
git clone https://github.com/adlee-was-taken/dotfiles_wiz.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --wizard
```

### Method 2: Quick Install

Uses defaults, asks for tool installations:

```bash
git clone https://github.com/adlee-was-taken/dotfiles_wiz.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

### Method 3: One-Liner

Downloads and runs installer:

```bash
curl -fsSL https://raw.githubusercontent.com/adlee-was-taken/dotfiles_wiz/main/install.sh | bash
```

### Method 4: Custom Configuration

Pre-configure before installing:

```bash
git clone https://github.com/adlee-was-taken/dotfiles_wiz.git ~/.dotfiles
cd ~/.dotfiles

# Edit configuration
vim dotfiles.conf

# Run installation with custom config
./install.sh
```

---

## Step-by-Step Setup

### 1. Prerequisites

**Minimum Requirements:**
- Git
- curl
- ZSH

**Optional but Recommended:**
- tmux (for workspace manager)
- fzf (for fuzzy search)
- Python 3.8+ (for Python templates)

**Check Prerequisites:**
```bash
# Check if installed
git --version
curl --version
zsh --version

# Install if missing (Debian/Ubuntu)
sudo apt update
sudo apt install -y git curl zsh

# Install if missing (macOS)
brew install git curl zsh
```

### 2. Clone Repository

```bash
git clone https://github.com/adlee-was-taken/dotfiles_wiz.git ~/.dotfiles
cd ~/.dotfiles
```

### 3. Configure (Optional)

Edit `dotfiles.conf` to customize before installation:

```bash
vim dotfiles.conf
```

**Key Settings:**

```bash
# Personal Information
USER_FULLNAME="Your Name"
USER_EMAIL="you@example.com"

# Git Configuration
GIT_DEFAULT_BRANCH="main"
GIT_CREDENTIAL_HELPER="store"

# Python Templates
PY_TEMPLATE_BASE_DIR="$HOME/projects"
PY_TEMPLATE_PYTHON="python3"
PY_TEMPLATE_USE_POETRY="false"

# SSH Manager
SSH_AUTO_TMUX="true"

# Tmux Workspaces
TW_DEFAULT_TEMPLATE="dev"

# Feature Toggles
ENABLE_ANALYTICS="true"
AUTO_COMPILE_ZSH="true"
INSTALL_ZSH_PLUGINS="true"

# Installation Preferences
INSTALL_TMUX="true"
INSTALL_FZF="true"
INSTALL_BAT="true"
INSTALL_EZA="true"
```

### 4. Run Installation

**Interactive Wizard:**
```bash
./install.sh --wizard
```

**Standard Installation:**
```bash
./install.sh
```

**Install Dependencies Only:**
```bash
./install.sh --deps-only
```

**Skip Dependencies:**
```bash
./install.sh --skip-deps
```

### 5. Reload Shell

```bash
exec zsh
```

---

## Feature Configuration

### SSH Session Manager

#### Automatic Setup (via wizard)

The wizard will ask you to add SSH connections during setup.

#### Manual Setup

```bash
# Add SSH connection
ssh-save prod user@prod.example.com 22 ~/.ssh/prod_key "Production server"

# Add another
ssh-save dev user@dev.local 22 "" "Development server"

# List all connections
ssh-list

# Connect
ssh-connect prod
```

#### Configuration Options

Edit `~/.dotfiles/dotfiles.conf`:

```bash
# Auto-create tmux session on SSH connect
SSH_AUTO_TMUX="true"

# Prefix for SSH tmux sessions
SSH_TMUX_SESSION_PREFIX="ssh-"

# Auto-sync dotfiles on connect
SSH_SYNC_DOTFILES="false"
```

#### Direct Profile Editing

Edit `~/.dotfiles/.ssh-profiles`:

```
prod|user@prod.example.com|22|~/.ssh/prod_key||Production server
dev|user@dev.local|22|||Development server
staging|user@staging.example.com|22|~/.ssh/staging_key||Staging environment
```

Format: `name|user@host|port|key_file|options|description`

### Tmux Workspace Manager

#### Automatic Setup (via wizard)

The wizard will create initial workspaces for you.

#### Manual Setup

```bash
# Create workspace with default template
tw myproject

# Create with specific template
tw-create backend dev
tw-create monitoring ops
tw-create debug debug

# Save current layout as template
tw-save my-custom-template
```

#### Configuration Options

Edit `~/.dotfiles/dotfiles.conf`:

```bash
# Prefix for workspace sessions
TW_SESSION_PREFIX="work-"

# Default template for new workspaces
TW_DEFAULT_TEMPLATE="dev"
```

#### Create Custom Templates

```bash
# 1. Create a workspace
tw-create test dev

# 2. Modify layout as desired
#    - Split panes
#    - Resize panes
#    - Set working directories

# 3. Save as template
tw-save my-template

# 4. Use your template
tw-create newproject my-template
```

### Python Project Templates

#### Configuration

Edit `~/.dotfiles/dotfiles.conf`:

```bash
# Base directory for projects
PY_TEMPLATE_BASE_DIR="$HOME/projects"

# Python interpreter to use
PY_TEMPLATE_PYTHON="python3"

# Virtual environment name
PY_TEMPLATE_VENV_NAME="venv"

# Use Poetry instead of pip
PY_TEMPLATE_USE_POETRY="false"

# Auto-initialize git repository
PY_TEMPLATE_GIT_INIT="true"
```

#### Usage

```bash
# Create projects
py-new myapp
py-django myblog
py-flask myapi
py-fastapi myservice
py-data analysis
py-cli mytool

# All projects include:
# - Virtual environment
# - .gitignore
# - README.md
# - Basic project structure
# - requirements.txt
```

---

## Post-Installation

### 1. Verify Installation

```bash
dfd
# or
dotfiles-doctor.sh
```

The doctor checks:
- Core dependencies
- Symlinks
- Shell configuration
- SSH manager
- Tmux workspaces
- Python templates
- Optional tools
- Performance settings

### 2. Install Optional Tools

If you skipped tools during installation:

```bash
# fzf (fuzzy finder - required for sshf/twf)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# bat (better cat)
sudo apt install bat         # Debian/Ubuntu
brew install bat             # macOS

# eza (better ls)
sudo apt install eza         # Debian/Ubuntu
brew install eza             # macOS

# tmux (required for workspace manager)
sudo apt install tmux        # Debian/Ubuntu
brew install tmux            # macOS

# espanso (text expander)
# Follow https://espanso.org/install/
```

### 3. Configure Git

If not set during installation:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
```

### 4. Set ZSH as Default Shell

If not set during installation:

```bash
chsh -s $(which zsh)
# Log out and log back in
```

### 5. Install ZSH Plugins

If not installed:

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Reload shell
exec zsh
```

### 6. Compile ZSH Functions

For better performance:

```bash
dfcompile
```

---

## Verification

### Test Core Functions

```bash
# Dotfiles commands
dfd              # Doctor
dfu              # Update
dfs              # Sync
dfstats          # Analytics
dfcompile        # Compile

# SSH manager
ssh-save test user@localhost
ssh-list
ssh-connect test  # (if you have a local SSH server)

# Tmux workspaces
tw test
tw-list
tw-delete test

# Python templates
cd /tmp
py-new testapp
ls testapp/
rm -rf testapp/

# Fuzzy search (if fzf installed)
sshf             # Ctrl+C to exit
twf              # Ctrl+C to exit
```

### Check Shell Analytics

```bash
# After using the shell for a while
dfstats

# Should show command usage statistics
```

### Verify Symlinks

```bash
ls -la ~/.zshrc
ls -la ~/.gitconfig
ls -la ~/.vimrc
ls -la ~/.tmux.conf

# All should point to ~/.dotfiles/...
```

---

## Troubleshooting

### Common Issues

#### 1. Commands not found

**Problem:** Commands like `tw`, `ssh-save`, `py-new` not found

**Solution:**
```bash
# Reload shell
exec zsh

# Or manually source
source ~/.zshrc

# Check if functions loaded
type tw
type ssh-save
type py-new
```

#### 2. tmux workspace commands fail

**Problem:** `tw` commands give errors

**Solution:**
```bash
# Install tmux
sudo apt install tmux         # Debian/Ubuntu
brew install tmux             # macOS

# Reload shell
exec zsh
```

#### 3. Fuzzy search (sshf/twf) not working

**Problem:** `sshf` and `twf` don't work

**Solution:**
```bash
# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
exec zsh
```

#### 4. Python templates create wrong version

**Problem:** Virtual environment uses wrong Python

**Solution:**
```bash
# Edit dotfiles.conf
vim ~/.dotfiles/dotfiles.conf

# Set specific version
PY_TEMPLATE_PYTHON="python3.11"

# Reload
exec zsh
```

#### 5. SSH connections won't save

**Problem:** `ssh-save` doesn't persist

**Solution:**
```bash
# Check dotfiles directory exists
ls -la ~/.dotfiles

# Create profiles file manually
mkdir -p ~/.dotfiles
touch ~/.dotfiles/.ssh-profiles

# Try saving again
ssh-save test user@localhost
```

#### 6. Symlinks not created

**Problem:** Files not linked to dotfiles

**Solution:**
```bash
# Re-run installation
cd ~/.dotfiles
./install.sh

# Or create symlinks manually
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
```

#### 7. oh-my-zsh not installed

**Problem:** ZSH theme or plugins missing

**Solution:**
```bash
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Re-run dotfiles installation
cd ~/.dotfiles
./install.sh --skip-deps
```

#### 8. Slow shell startup

**Problem:** Shell takes long to start

**Solution:**
```bash
# Compile ZSH functions
dfcompile

# Enable deferred loading in dotfiles.conf
DEFER_LOAD_FUNCTIONS="true"

# Disable analytics if not needed
ENABLE_ANALYTICS="false"

# Reload
exec zsh
```

### Getting Help

#### 1. Run Doctor

```bash
dfd --verbose
```

#### 2. Check Logs

```bash
# View ZSH startup issues
zsh -x

# Check tmux issues
tmux list-sessions
tmux info
```

#### 3. Review Configuration

```bash
cat ~/.dotfiles/dotfiles.conf
```

#### 4. Check GitHub Issues

Visit: https://github.com/adlee-was-taken/dotfiles_wiz/issues

---

## Updating

### Update Dotfiles

```bash
dfu
# or
dfupdate
```

### Re-run Setup Wizard

```bash
cd ~/.dotfiles
./setup/setup-wizard.sh
```

### Manual Update

```bash
cd ~/.dotfiles
git pull origin main
./install.sh --skip-deps
exec zsh
```

---

## Uninstallation

### Remove Symlinks and Restore Backups

```bash
cd ~/.dotfiles
./install.sh --uninstall
```

### Complete Removal

```bash
cd ~/.dotfiles
./install.sh --uninstall --purge
```

This will:
- Remove all symlinks
- Restore backup files
- Delete ~/.dotfiles directory (if --purge)

### Manual Cleanup

```bash
# Remove symlinks
rm ~/.zshrc ~/.gitconfig ~/.vimrc ~/.tmux.conf

# Remove dotfiles directory
rm -rf ~/.dotfiles

# Remove bin scripts
rm -rf ~/.local/bin/dotfiles-*

# Change shell back to bash
chsh -s /bin/bash

# Remove oh-my-zsh (optional)
rm -rf ~/.oh-my-zsh
```

---

## Next Steps

1. **Explore Features**: Try out SSH manager, tmux workspaces, Python templates
2. **Read Documentation**: 
   - `cat ~/.dotfiles/README.md`
   - `cat ~/.dotfiles/SSH_TMUX_INTEGRATION.md`
   - `cat ~/.dotfiles/QUICKSTART.md`
3. **Customize**: Edit `~/.dotfiles/dotfiles.conf`
4. **Share**: Star the repo and share your setup!

---

## Support

- **Documentation**: `~/.dotfiles/README.md`
- **Quick Start**: `~/.dotfiles/QUICKSTART.md`
- **Health Check**: `dfd`
- **GitHub Issues**: https://github.com/adlee-was-taken/dotfiles_wiz/issues
- **Discussions**: https://github.com/adlee-was-taken/dotfiles_wiz/discussions

---

**Happy coding! 🚀**
