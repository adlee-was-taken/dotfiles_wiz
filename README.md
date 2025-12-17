# dotfiles_wiz v1.2.0

> A powerful, modular dotfiles setup with SSH management, tmux workspaces, and Python project templates.

[![Version](https://img.shields.io/badge/version-1.2.0-blue.svg)](https://github.com/adlee-was-taken/dotfiles)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-zsh-orange.svg)](https://www.zsh.org/)

## ✨ Features

### 🚀 New in v1.2.0

- **SSH Session Manager** - Save, manage, and quickly connect to SSH hosts with auto-tmux integration
- **Tmux Workspace Manager** - Project-based tmux layouts with templates and fuzzy search
- **Python Project Templates** - Scaffolding for Django, Flask, FastAPI, data science, and CLI projects
- **Interactive Setup Wizard** - Guided configuration for first-time setup

### 🔧 Core Features

- **Smart Shell Configuration** - ZSH with oh-my-zsh, custom theme, and intelligent plugins
- **Git Integration** - Pre-configured aliases, credential helpers, and workflow optimization
- **Developer Toolbox** - fzf, bat, eza, espanso, and more
- **Secrets Management** - CLI integration with 1Password, LastPass, and Bitwarden
- **Performance Optimization** - Deferred loading, compiled functions, analytics
- **Modular Architecture** - Easy to customize and extend

## 📦 Quick Install

```bash
# Clone and install
git clone https://github.com/adlee-was-taken/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --wizard

# Or one-liner (curl)
curl -fsSL https://raw.githubusercontent.com/adlee-was-taken/dotfiles/main/install.sh | bash
```

### Installation Options

```bash
./install.sh                    # Full installation
./install.sh --wizard           # Interactive setup wizard (recommended)
./install.sh --skip-deps        # Skip dependency installation
./install.sh --deps-only        # Only install dependencies
./install.sh --uninstall        # Remove symlinks and restore backups
./install.sh --help             # Show all options
```

## 🎯 Quick Start

### SSH Session Manager

```bash
# Save SSH connections
ssh-save prod user@prod.server.com 22 ~/.ssh/prod_key "Production server"
ssh-save staging user@staging.local

# Connect (auto-creates tmux session on remote)
ssh-connect prod
ssh-connect staging

# Fuzzy search and connect
sshf

# Reconnect to last session
ssh-reconnect

# Deploy dotfiles to remote
ssh-sync-dotfiles prod

# List all connections
ssh-list
sshl
```

### Tmux Workspace Manager

```bash
# Quick create/attach
tw myproject

# Create with specific template
tw-create backend dev      # 3-pane dev layout
tw-create monitoring ops   # 4-pane grid
tw-create logs debug       # 2-pane debug layout

# Fuzzy search workspaces
twf

# List active workspaces
tw-list
twl

# Save custom template
tw-save my-template

# Toggle pane synchronization (type in all panes)
tw-sync

# Delete workspace
tw-delete myproject
```

### Python Project Templates

```bash
# Basic Python project
py-new myapp
cd myapp && source venv/bin/activate

# Django web application
py-django myblog
cd myblog && python manage.py runserver

# Flask web application
py-flask myapi
cd myapi && flask run

# FastAPI REST API
py-fastapi myservice
cd myservice && uvicorn main:app --reload

# Data science project
py-data analysis
cd analysis && jupyter notebook

# CLI tool
py-cli mytool
cd mytool && python -m mytool --help
```

### Combined Workflows

```bash
# Example 1: Remote development with tmux
ssh-save backend user@backend.prod.com
tw-create backend dev              # Create local workspace
ssh-connect backend                # Auto-creates remote tmux session

# Example 2: Multi-server monitoring
tw-create monitoring ssh-multi     # 4-pane layout
# Connect to different servers in each pane
tw-sync                            # Synchronize input across all panes

# Example 3: Python project on remote server
ssh-connect dev-server
tw django-project                  # Create workspace on remote
py-django myproject                # Create Django project
```

## 🗂️ Project Structure

```
~/.dotfiles/
├── install.sh                 # Main installation script
├── dotfiles.conf             # Configuration file
├── README.md                 # This file
├── CHANGELOG_v1.2.0.md      # Version history
├── SSH_TMUX_INTEGRATION.md  # SSH & tmux guide
│
├── setup/
│   └── setup-wizard.sh       # Interactive setup wizard
│
├── zsh/
│   ├── .zshrc                # Main ZSH config
│   ├── themes/               # ZSH themes
│   │   └── adlee.zsh-theme
│   ├── aliases.zsh           # Command aliases
│   └── functions/
│       ├── python-templates.zsh    # Python project templates
│       ├── ssh-manager.zsh         # SSH connection manager
│       ├── tmux-workspaces.zsh     # Tmux workspace manager
│       ├── analytics.zsh           # Command analytics
│       ├── dotfiles-cli.zsh        # Dotfiles management
│       └── vault.zsh               # Secrets management
│
├── git/
│   └── .gitconfig            # Git configuration
│
├── tmux/
│   └── .tmux.conf            # Tmux configuration
│
├── vim/
│   └── .vimrc                # Vim configuration
│
├── espanso/
│   ├── config/               # Espanso settings
│   └── match/                # Text expansion rules
│
└── bin/
    ├── dotfiles-doctor.sh    # Health check script
    ├── dotfiles-sync.sh      # Sync utility
    └── dotfiles-update.sh    # Update utility
```

## ⚙️ Configuration

All settings are in `~/.dotfiles/dotfiles.conf`. Key options:

```bash
# Personal Information
USER_FULLNAME="Your Name"
USER_EMAIL="you@example.com"

# Python Templates
PY_TEMPLATE_BASE_DIR="$HOME/projects"
PY_TEMPLATE_PYTHON="python3"
PY_TEMPLATE_USE_POETRY="false"
PY_TEMPLATE_GIT_INIT="true"

# SSH Manager
SSH_AUTO_TMUX="true"
SSH_TMUX_SESSION_PREFIX="ssh-"

# Tmux Workspaces
TW_SESSION_PREFIX="work-"
TW_DEFAULT_TEMPLATE="dev"

# Feature Toggles
ENABLE_ANALYTICS="true"
AUTO_COMPILE_ZSH="true"
INSTALL_ZSH_PLUGINS="true"
```

## 📝 Available Tmux Templates

| Template | Layout | Use Case |
|----------|--------|----------|
| `dev` | Editor (50%), terminal (25%), logs (25%) | General development |
| `ops` | 4-pane grid | System monitoring |
| `ssh-multi` | 4-pane grid | Multi-server management |
| `debug` | Main (70%), helper (30%) | Debugging sessions |
| `full` | Single pane | Simple tasks |
| `review` | Side-by-side | Code review |

## 🛠️ Dotfiles Management Commands

```bash
# Health check
dfd
doctor

# Update dotfiles from GitHub
dfu
dfupdate

# Sync dotfiles to GitHub
dfs
dfsync

# View command analytics
dfstats

# Compile ZSH functions for speed
dfcompile

# Edit configuration
dfe
```

## 🔐 Password Manager Integration

Supports CLI tools for:
- **1Password** (`op`) - `vault 1password <item>`
- **LastPass** (`lpass`) - `vault lastpass <item>`
- **Bitwarden** (`bw`) - `vault bitwarden <item>`

```bash
# Quick access to secrets
vault 1password github-token
vault lastpass aws-key
vault bitwarden database-password
```

## 🎨 Customization

### Add Your Own SSH Connections

```bash
# Edit or use ssh-save
ssh-save myserver user@host.com 22 ~/.ssh/key "Description"
```

### Create Custom Tmux Templates

```bash
# Set up your perfect layout
tw-create myproject dev

# Modify the panes as needed, then save
tw-save my-custom-template

# Use your template
tw-create newproject my-custom-template
```

### Extend Python Templates

Edit `~/.dotfiles/zsh/functions/python-templates.zsh`:

```bash
py-myframework() {
    # Your custom template here
}
```

## 🔄 Updates

```bash
# Check for updates
dfu

# Or manually
cd ~/.dotfiles
git pull origin main
./install.sh --skip-deps
```

Set `AUTO_UPDATE_DOTFILES="true"` in `dotfiles.conf` for automatic updates.

## 🐛 Troubleshooting

### Run the Doctor

```bash
dfd
# or
dotfiles-doctor.sh
```

The doctor checks:
- Required dependencies
- Symlink integrity
- Configuration validity
- Tool availability
- Performance issues

### Common Issues

**Tmux workspaces not working?**
```bash
# Install tmux
./install.sh --deps-only
# Or manually: sudo apt install tmux (or brew install tmux)
```

**SSH fuzzy search (sshf) not working?**
```bash
# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
```

**Python templates creating wrong Python version?**
```bash
# Set in dotfiles.conf
PY_TEMPLATE_PYTHON="python3.11"  # Or your preferred version
```

## 📚 Documentation

- [SSH & Tmux Integration Guide](SSH_TMUX_INTEGRATION.md)
- [Changelog v1.2.0](CHANGELOG_v1.2.0.md)
- [Contributing Guidelines](CONTRIBUTING.md)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

MIT License - feel free to use and modify!

## 🙏 Credits

- Inspired by [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- [tmux](https://github.com/tmux/tmux)

## ⭐ Support

If you find this useful, please star the repository!

---

**Made with ❤️ by ADLee** | [Report Issues](https://github.com/adlee-was-taken/dotfiles/issues) | [Suggest Features](https://github.com/adlee-was-taken/dotfiles/discussions)
