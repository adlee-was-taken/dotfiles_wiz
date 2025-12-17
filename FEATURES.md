# dotfiles_wiz Features

## Core Features (Always Enabled)

These features are always loaded and available:

### 1. SSH Manager (`ssh-manager.zsh`)
**Size:** 15KB | **Commands:** `ssh-save`, `ssh-connect`, `ssh-list`, `sshf`

- Save and manage SSH connections
- Auto-tmux integration
- Fuzzy search with fzf
- Connection profiles and aliases

**Example:**
```bash
ssh-save prod user@production.com
ssh-connect prod                    # Auto-creates tmux session
sshf                                # Fuzzy search connections
```

### 2. Tmux Workspace Manager (`tmux-workspaces.zsh`)
**Size:** 18KB | **Commands:** `tw`, `tw-create`, `tw-list`, `twf`, `tw-sync`

- Project-based workspace management
- Multiple templates (dev, fullstack, data, ops)
- Pane synchronization
- Fuzzy search workspaces

**Example:**
```bash
tw myproject                        # Create/attach workspace
tw-create backend dev               # Use dev template
twf                                 # Fuzzy search
tw-sync                             # Type in all panes
```

### 3. Python Project Templates (`python-templates.zsh`)
**Size:** 32KB | **Commands:** `py-new`, `py-django`, `py-flask`, `py-fastapi`, `py-data`, `py-cli`

- Quick-start Python projects
- Multiple frameworks (Django, Flask, FastAPI)
- Data science templates
- CLI app scaffolding
- Auto venv setup

**Example:**
```bash
py-django myblog                    # Django project
py-flask myapi                      # Flask API
py-data analysis                    # Data science project
```

### 4. Custom MOTD (`motd.zsh`)
**Size:** 6KB | **Commands:** `show_motd`, `motd`

- Beautiful system information display
- Shows: hostname, OS, uptime, load, disk, memory
- Customizable format
- Shows on login

---

## Optional Features (User-Selectable)

These features can be enabled/disabled during setup or in `dotfiles.conf`:

### 5. Command Palette (`command-palette.zsh`) 🎨
**Size:** 11KB | **Commands:** `palette`, `p`, `bookmark`, `jump`  
**Keybinding:** Ctrl+Space | **Requires:** fzf

A Raycast/Alfred-style command launcher for your terminal.

**Features:**
- Search aliases, functions, recent commands
- Git commands (status, pull, push, diff, log, stash)
- Docker commands (ps, images, compose)
- Bookmarked directories
- Quick actions (reload shell, edit configs)
- Recent directories from dirstack

**Commands:**
```bash
palette                             # Open command palette
p                                   # Short alias
bookmark projects ~/projects        # Add bookmark
jump projects                       # Jump to bookmark (or: j projects)
```

**Keybindings:**
- `Ctrl+Space` or `Ctrl+P` - Open palette
- `Ctrl+E` - Edit command without executing
- `Ctrl+Y` - Copy command to clipboard
- `Ctrl+R` - Reload entries

**Enable/Disable:**
```bash
# In dotfiles.conf
ENABLE_COMMAND_PALETTE="true"   # or "false"
```

---

### 6. Password Manager Integration (`password-manager.zsh`) 🔐
**Size:** 12KB | **Commands:** `pw`, `pwf`, `pwof`  
**Requires:** One of: `op` (1Password), `lpass` (LastPass), `bw` (Bitwarden)

Unified CLI interface for password managers.

**Features:**
- Auto-detects which password manager you use
- Simple, consistent commands across all providers
- OTP/2FA support
- Fuzzy search with fzf
- Clipboard integration

**Commands:**
```bash
pw list                             # List all items
pw get github                       # Get password
pw get github username              # Get username
pw otp github                       # Get 2FA code
pw copy aws                         # Copy password to clipboard
pw search mail                      # Search items
pw provider                         # Show current provider
pw lock                             # Lock/sign out

# With fzf
pwf                                 # Interactive password selection
pwof                                # Interactive OTP selection
```

**Supported Fields:**
- `password` (default)
- `username`
- `url`
- `notes`
- Custom field names

**Enable/Disable:**
```bash
# In dotfiles.conf
ENABLE_PASSWORD_MANAGER="true"  # or "false"
PASSWORD_MANAGER="auto"         # or "1password", "lastpass", "bitwarden"
```

---

### 7. Smart Suggest (`smart-suggest.zsh`) 💡
**Size:** 12KB | **Commands:** `fuck`

Intelligent command suggestions and typo correction.

**Features:**
- Auto-correct common typos (200+ corrections built-in)
- Suggest package installation for missing commands
- Track frequently used commands
- Suggest alias creation for repeated commands
- "Did you mean?" for unknown commands

**Example Typo Corrections:**
```bash
$ gti status                        # Autocorrects to: git status
$ dokcer ps                         # Autocorrects to: docker ps
$ pytohn script.py                  # Autocorrects to: python script.py
$ suod apt install                  # Autocorrects to: sudo apt install
```

**Alias Suggestions:**
```bash
# After typing "docker-compose up -d" 10 times:
💡 Tip: You've typed 'docker-compose up -d' 10 times
   Consider adding: alias dcu='docker-compose up -d'
```

**Quick Fix:**
```bash
$ gti push
✗ Command not found: gti
→ Did you mean: git?

$ fuck                              # Runs: git push
```

**Supported Typos Include:**
- Git commands: `gti`, `got`, `gut`, `giit`, `stauts`, `comit`, `chekcout`, etc.
- Docker: `dokcer`, `doker`, `docekr`, `docker-compoes`
- Common tools: `pytohn`, `ndoe`, `npn`, `yran`, `suod`, `sssh`, `vmi`
- File operations: `cta`, `grpe`, `mkdri`, `rn`, `chmdo`, `chowd`

**Enable/Disable:**
```bash
# In dotfiles.conf
ENABLE_SMART_SUGGEST="true"         # or "false"
SMART_SUGGEST_TYPOS="true"          # Typo correction
SMART_SUGGEST_ALIASES="true"        # Alias suggestions
SMART_SUGGEST_PACKAGES="true"       # Package installation hints
```

---

## Configuration

All features are configured in `~/.dotfiles/dotfiles.conf`:

```bash
# ============================================================================
# Optional Features
# ============================================================================

# Command Palette - Fuzzy command launcher (Ctrl+Space)
ENABLE_COMMAND_PALETTE="true"

# Password Manager - Unified pw command
ENABLE_PASSWORD_MANAGER="true"
PASSWORD_MANAGER="auto"              # or 1password, lastpass, bitwarden

# Smart Suggest - Typo correction and suggestions
ENABLE_SMART_SUGGEST="true"
SMART_SUGGEST_TYPOS="true"
SMART_SUGGEST_ALIASES="true"
SMART_SUGGEST_PACKAGES="true"
```

Changes take effect after reloading your shell:
```bash
exec zsh
```

---

## Feature Dependencies

| Feature | Required | Optional |
|---------|----------|----------|
| SSH Manager | - | tmux (for auto-tmux), fzf (for sshf) |
| Tmux Workspaces | tmux | fzf (for twf) |
| Python Templates | python3 | poetry (optional) |
| MOTD | - | - |
| Command Palette | fzf | - |
| Password Manager | op/lpass/bw | jq (for pretty output) |
| Smart Suggest | - | - |

---

## Usage Statistics

After installation, you can check which features are enabled:

```bash
dfd                                 # Doctor command shows active features
dfstats                             # Show usage statistics
```

To enable/disable features later:

1. Edit `~/.dotfiles/dotfiles.conf`
2. Change `ENABLE_<FEATURE>="true"` to `"false"` (or vice versa)
3. Reload: `exec zsh`
