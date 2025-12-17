# Quick Start Guide - Dotfiles v1.2.0

## 🚀 Get Started in 5 Minutes

### 1. Install Dotfiles

```bash
# Clone and run interactive setup
git clone https://github.com/adlee-was-taken/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --wizard

# Follow the wizard prompts to configure:
# - Personal info
# - Git settings
# - Tool preferences
# - SSH connections
# - Tmux workspaces
# - Python projects
```

### 2. Reload Your Shell

```bash
exec zsh
```

### 3. Verify Installation

```bash
dfd
# or
dotfiles-doctor.sh
```

---

## 🔑 Core Workflows

### SSH Connection Management

**Save a connection:**
```bash
ssh-save prod user@prod.example.com 22 ~/.ssh/prod_key "Production server"
```

**Connect (auto-creates tmux session):**
```bash
ssh-connect prod
```

**Quick connect with fuzzy search:**
```bash
sshf
# Type to filter, Enter to connect
```

**Reconnect to last session:**
```bash
ssh-reconnect
```

---

### Tmux Workspace Manager

**Create or attach to workspace:**
```bash
tw myproject
# First time: creates workspace with default template
# Next times: attaches to existing workspace
```

**Create with specific template:**
```bash
tw-create backend dev        # 3-pane development layout
tw-create monitoring ops     # 4-pane grid for monitoring
tw-create debug debug        # 2-pane debug layout
```

**Quick attach with fuzzy search:**
```bash
twf
# Type to filter, Enter to attach
```

**List active workspaces:**
```bash
tw-list
```

**Save current layout as template:**
```bash
# Set up your perfect layout, then:
tw-save my-custom-template
```

**Synchronize input across panes:**
```bash
tw-sync
# Type once, execute in all panes
```

---

### Python Project Templates

**Create basic Python project:**
```bash
py-new myapp
cd myapp
source venv/bin/activate
```

**Create Django project:**
```bash
py-django myblog
cd myblog
python manage.py runserver
```

**Create Flask API:**
```bash
py-flask myapi
cd myapi
flask run
```

**Create FastAPI service:**
```bash
py-fastapi myservice
cd myservice
uvicorn main:app --reload
```

**Create data science project:**
```bash
py-data analysis
cd analysis
jupyter notebook
```

**Create CLI tool:**
```bash
py-cli mytool
cd mytool
python -m mytool --help
```

---

## 🎯 Combined Workflows

### Remote Development Workflow

```bash
# 1. Save your development server
ssh-save dev user@dev.example.com

# 2. Create a local workspace
tw-create dev-env dev

# 3. Connect (auto-creates remote tmux session)
ssh-connect dev

# 4. Create Python project on remote
py-django myproject
cd myproject
python manage.py runserver
```

### Multi-Server Monitoring

```bash
# 1. Create 4-pane workspace
tw-create monitoring ssh-multi

# 2. Connect to different servers in each pane
# Pane 1: ssh-connect web1
# Pane 2: ssh-connect web2
# Pane 3: ssh-connect db
# Pane 4: ssh-connect cache

# 3. Synchronize input
tw-sync
# Now type once, execute everywhere
tail -f /var/log/nginx/access.log
```

### Local Development + Remote Deployment

```bash
# 1. Create local project
py-flask myapi
cd myapi

# 2. Create workspace
tw myapi

# 3. Add remote deployment server
ssh-save deploy user@deploy.example.com

# 4. Deploy dotfiles to remote
ssh-sync-dotfiles deploy

# 5. Deploy your project
rsync -avz . deploy:~/myapi/
ssh-connect deploy
cd myapi && flask run
```

---

## 📋 Available Templates

### Tmux Workspace Templates

| Template | Layout | Best For |
|----------|--------|----------|
| `dev` | Editor 50% / Terminal 25% / Logs 25% | General development |
| `ops` | 4-pane grid | Monitoring multiple services |
| `ssh-multi` | 4-pane grid | Multi-server management |
| `debug` | Main 70% / Helper 30% | Debugging sessions |
| `full` | Single pane | Simple tasks |
| `review` | Side-by-side 50/50 | Code review |

### Python Project Templates

| Command | Framework | Includes |
|---------|-----------|----------|
| `py-new` | Basic | venv, tests, .gitignore, README |
| `py-django` | Django | Project structure, settings, urls |
| `py-flask` | Flask | Blueprints, templates, static files |
| `py-fastapi` | FastAPI | Routes, models, auto-docs |
| `py-data` | Jupyter | Notebooks, data folders, requirements |
| `py-cli` | Click | CLI structure, commands, help |

---

## 🛠️ Essential Commands

### Dotfiles Management
```bash
dfd           # Health check
dfu           # Update from GitHub
dfs           # Sync to GitHub
dfstats       # Command analytics
dfcompile     # Compile ZSH for speed
dfe           # Edit config
```

### SSH Manager
```bash
ssh-save <name> <user@host>      # Save connection
ssh-connect <name>               # Connect
sshf                             # Fuzzy search
sshl                             # List connections
ssh-reconnect                    # Reconnect to last
ssh-sync-dotfiles <name>         # Deploy dotfiles
```

### Tmux Workspaces
```bash
tw <name>                        # Create/attach
tw-create <name> [template]      # Create with template
twf                              # Fuzzy search
twl                              # List workspaces
tw-save <template>               # Save current layout
tw-sync                          # Toggle sync
tw-delete <name>                 # Delete workspace
```

### Python Templates
```bash
py-new <name>                    # Basic project
py-django <name>                 # Django app
py-flask <name>                  # Flask app
py-fastapi <name>                # FastAPI service
py-data <name>                   # Data science
py-cli <name>                    # CLI tool
venv                             # Activate venv in current dir
```

---

## ⚙️ Configuration

Edit `~/.dotfiles/dotfiles.conf`:

```bash
# Python Templates
PY_TEMPLATE_BASE_DIR="$HOME/projects"
PY_TEMPLATE_PYTHON="python3"
PY_TEMPLATE_USE_POETRY="false"
PY_TEMPLATE_GIT_INIT="true"

# SSH Manager
SSH_AUTO_TMUX="true"              # Auto-create tmux on connect
SSH_TMUX_SESSION_PREFIX="ssh-"    # Prefix for SSH sessions

# Tmux Workspaces
TW_SESSION_PREFIX="work-"         # Prefix for workspaces
TW_DEFAULT_TEMPLATE="dev"         # Default template

# Features
ENABLE_ANALYTICS="true"           # Track command usage
AUTO_COMPILE_ZSH="true"           # Auto-compile for speed
```

---

## 🐛 Troubleshooting

### Command not found

```bash
# Reload shell
exec zsh

# Or re-source config
source ~/.zshrc
```

### tmux not working

```bash
# Install tmux
sudo apt install tmux      # Debian/Ubuntu
sudo pacman -S tmux        # Arch
brew install tmux          # macOS
```

### Fuzzy search (sshf/twf) not working

```bash
# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
exec zsh
```

### Python template issues

```bash
# Check Python version
python3 --version

# Install venv module
sudo apt install python3-venv python3-pip

# Set Python version in config
# Edit ~/.dotfiles/dotfiles.conf:
PY_TEMPLATE_PYTHON="python3.11"
```

### SSH connection won't save

```bash
# Check if dotfiles directory exists
ls -la ~/.dotfiles

# Manually create profiles file
mkdir -p ~/.dotfiles
touch ~/.dotfiles/.ssh-profiles

# Re-save connection
ssh-save myserver user@host.com
```

---

## 📚 Next Steps

1. **Explore Features**: Try `dfd` to see all available commands
2. **Customize**: Edit `~/.dotfiles/dotfiles.conf` for your preferences
3. **Read Docs**: Check `~/.dotfiles/README.md` and `SSH_TMUX_INTEGRATION.md`
4. **Join Community**: Star the repo and share your setup!

---

## 🔗 Resources

- **Full README**: `~/.dotfiles/README.md`
- **SSH/Tmux Guide**: `~/.dotfiles/SSH_TMUX_INTEGRATION.md`
- **Changelog**: `~/.dotfiles/CHANGELOG_v1.2.0.md`
- **GitHub**: https://github.com/adlee-was-taken/dotfiles

---

**Questions?** Run `dfd` for health check or open an issue on GitHub!
