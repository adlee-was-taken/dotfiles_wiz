# 🧙 dotfiles_wiz - Universal Dotfiles Framework

**A complete, standalone dotfiles management system that works for everyone.**

Two modes. One installer. Infinite possibilities.

---

## 🎯 What Is This?

`dotfiles_wiz` is a universal dotfiles installer and framework that:

✅ Works immediately with bundled, production-ready dotfiles  
✅ Can use your own existing dotfiles repository  
✅ Includes SSH manager, tmux workspaces, Python templates  
✅ Has interactive setup wizard for first-timers  
✅ Manages installation, updates, and health checks  

---

## 🚀 Quick Start (60 seconds)

```bash
# 1. Clone
git clone https://github.com/adlee-was-taken/dotfiles_wiz.git
cd dotfiles_wiz

# 2. Install
./install.sh

# 3. Choose your mode
? Do you have an existing dotfiles repository? [y/N]: n
✓ Using bundled dotfiles

# 4. Done!
exec zsh
```

---

## 📦 What You Get

### Core Features (Always Enabled)

- **SSH Session Manager** - Save connections, auto-tmux, fuzzy search (`ssh-save`, `sshf`)
- **Tmux Workspace Manager** - Project layouts, templates, pane sync (`tw`, `twf`)
- **Python Project Templates** - Django, Flask, FastAPI, data science, CLI (`py-django`, `py-flask`)
- **Custom MOTD** - Beautiful system info display on login

### Optional Features (Enable During Setup)

- **Command Palette** 🎨 - Fuzzy command launcher (Ctrl+Space)
  - Search aliases, functions, history, git/docker commands
  - Quick actions and bookmarks
  - Requires: fzf
  
- **Password Manager Integration** 🔐 - Unified CLI for password managers
  - Commands: `pw get`, `pw otp`, `pw search`, `pw copy`
  - Auto-detects 1Password, LastPass, or Bitwarden
  - Requires: `op`, `lpass`, or `bw` CLI
  
- **Smart Suggest** 💡 - Intelligent command suggestions
  - Auto-correct typos (`gti` → `git`, `dokcer` → `docker`)
  - Suggest package installation for missing commands
  - Track frequent commands and suggest aliases

### Additional Features

- **Command Analytics** - Track usage patterns (`dfstats`)
- **Secrets Management** - Vault integration
- **Smart Aliases** - Curated productivity shortcuts
- **Auto-Updates** - Keep everything in sync (`dfu`)

### Professional Defaults

- ZSH with oh-my-zsh
- Vim configuration
- Git aliases and workflows
- Tmux keybindings
- Espanso text expansion

---

## 🛠️ Installation Modes

### Mode 1: Bundled Dotfiles (Recommended)

Perfect for first-time users or starting fresh:

```bash
./install.sh --local
```

Gets you a fully-featured setup instantly!

### Mode 2: Your Own Repository

Already have dotfiles? Use them:

```bash
./install.sh --repo https://github.com/you/dotfiles.git
```

### Mode 3: Interactive

Let the installer guide you:

```bash
./install.sh          # Asks about existing repo
./install.sh --wizard # Full setup wizard
```

---

## 📖 Quick Examples

### SSH Manager
```bash
ssh-save prod user@prod.com    # Save connection
ssh-connect prod                # Connect with auto-tmux
sshf                           # Fuzzy search
```

### Tmux Workspaces
```bash
tw myproject                   # Create/attach workspace
tw-create backend dev          # Use dev template
twf                            # Fuzzy search
tw-sync                        # Type in all panes
```

### Python Templates
```bash
py-django myblog               # Django project
py-flask myapi                 # Flask API
py-data analysis               # Data science
```

### Command Palette (Optional Feature)
```bash
# Press Ctrl+Space to open fuzzy command launcher
# Search aliases, functions, git/docker commands, bookmarks
palette                        # Or use: p
bookmark projects ~/projects   # Add bookmark
jump projects                  # Quick jump: j projects
```

### Password Manager (Optional Feature)
```bash
pw list                        # List all passwords
pw get github                  # Get password
pw otp github                  # Get 2FA code
pw copy aws                    # Copy to clipboard
pwf                            # Fuzzy search with fzf
```

### Smart Suggest (Optional Feature)
```bash
$ gti status                   # Typo correction
→ Did you mean: git status?

$ dokcer ps                    # Suggests fix
→ Did you mean: docker?

# After typing "docker-compose up -d" 10 times:
💡 Tip: Consider adding: alias dcu='docker-compose up -d'
```

---

## 📂 Project Structure

```
dotfiles_wiz/
├── install.sh              # Universal installer
├── setup/
│   └── setup-wizard.sh     # Interactive setup
├── bin/
│   └── dotfiles-doctor.sh  # Health checks
└── dotfiles/               # Bundled starter pack
    ├── zsh/
    │   ├── .zshrc
    │   ├── aliases.zsh
    │   └── functions/
    │       ├── ssh-manager.zsh
    │       ├── tmux-workspaces.zsh
    │       ├── python-templates.zsh
    │       └── ...
    ├── git/.gitconfig
    ├── vim/.vimrc
    └── tmux/.tmux.conf
```

---

## 🔧 After Installation

```bash
# Verify installation
dfd

# Check features
ssh-list              # Your SSH connections
tw-list              # Your tmux workspaces  
py-new testapp       # Test Python templates

# Update
dfu                   # Update dotfiles
```

---

## 🎨 Customization

Edit `~/.dotfiles/dotfiles.conf`:

```bash
# Personal info
USER_FULLNAME="Your Name"
USER_EMAIL="you@example.com"

# Python settings
PY_TEMPLATE_BASE_DIR="$HOME/projects"
PY_TEMPLATE_PYTHON="python3.11"

# SSH settings
SSH_AUTO_TMUX="true"

# Optional features (toggle on/off)
ENABLE_COMMAND_PALETTE="true"    # Ctrl+Space command launcher
ENABLE_PASSWORD_MANAGER="true"   # pw command for passwords
ENABLE_SMART_SUGGEST="true"      # Typo correction

# Other features
ENABLE_ANALYTICS="true"
```

---

## 📚 Full Documentation

- [README.md](README.md) - Complete features and usage
- [QUICKSTART.md](QUICKSTART.md) - 5-minute guide
- [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md) - Detailed installation
- [SSH_TMUX_INTEGRATION.md](SSH_TMUX_INTEGRATION.md) - Advanced workflows

---

## 🐛 Troubleshooting

```bash
# Health check
dfd --verbose

# Common fixes
exec zsh                      # Reload shell
sudo apt install tmux fzf     # Install dependencies
```

See [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md) for complete troubleshooting.

---

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repo
2. Create a feature branch
3. Test thoroughly
4. Submit a PR

---

## 📄 License

MIT License - use and modify freely!

---

## ⭐ Support

- Star the repo if you find it useful!
- [Report issues](https://github.com/adlee-was-taken/dotfiles_wiz/issues)
- [Suggest features](https://github.com/adlee-was-taken/dotfiles_wiz/discussions)

---

**Made with ❤️ by [ADLee](https://github.com/adlee-was-taken)**

*Empowering developers with better dotfiles since 2025* 🚀
