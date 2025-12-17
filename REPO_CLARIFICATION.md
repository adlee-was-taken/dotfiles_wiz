# Repository Structure - Important Note

## 🔍 Two Separate Repositories

This project uses **two separate repositories** with different purposes:

---

### 1. **dotfiles_wiz** (This Repo - Public Framework)

**URL:** `https://github.com/adlee-was-taken/dotfiles_wiz.git`

**Purpose:** Universal dotfiles installer and framework

**Contains:**
- Universal installer (`install.sh`)
- Setup wizard
- Health check utilities
- Bundled starter dotfiles (templates)
- Complete documentation

**Who uses it:**
- Anyone wanting to use dotfiles_wiz
- First-time dotfiles users
- People wanting a great starting point

**Clone with:**
```bash
git clone https://github.com/adlee-was-taken/dotfiles_wiz.git
cd dotfiles_wiz
./install.sh
```

---

### 2. **dotfiles** (Personal - Private/Separate)

**URL:** `https://github.com/adlee-was-taken/dotfiles.git`

**Purpose:** ADLee's personal dotfiles repository

**Contains:**
- Personal configurations
- Private settings
- Custom scripts specific to ADLee's setup
- May contain private data (SSH keys, etc.)

**Who uses it:**
- ADLee (the maintainer)
- Can be used by others as a reference

**Use with dotfiles_wiz:**
```bash
git clone https://github.com/adlee-was-taken/dotfiles_wiz.git
cd dotfiles_wiz
./install.sh --repo https://github.com/adlee-was-taken/dotfiles.git
```

---

## 📊 How They Work Together

```
┌─────────────────────────────────────────────────────────────┐
│ dotfiles_wiz (Public)                                       │
│ https://github.com/adlee-was-taken/dotfiles_wiz.git         │
├─────────────────────────────────────────────────────────────┤
│ • Universal installer                                       │
│ • Works with ANY dotfiles repo                              │
│ • Includes bundled starter dotfiles                         │
│ • Anyone can clone and use immediately                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ Can optionally use
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ dotfiles (ADLee's Personal)                                 │
│ https://github.com/adlee-was-taken/dotfiles.git             │
├─────────────────────────────────────────────────────────────┤
│ • ADLee's personal configurations                           │
│ • Private/custom settings                                   │
│ • Can be used with dotfiles_wiz installer                   │
│ • May be private repository                                 │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Usage Examples

### Example 1: New User (No Existing Dotfiles)

```bash
# Clone dotfiles_wiz
git clone https://github.com/adlee-was-taken/dotfiles_wiz.git
cd dotfiles_wiz

# Use bundled dotfiles (default)
./install.sh
# ? Do you have an existing dotfiles repository? [y/N]: n
# ✓ Using bundled dotfiles
```

### Example 2: User With Their Own Dotfiles

```bash
# Clone dotfiles_wiz
git clone https://github.com/adlee-was-taken/dotfiles_wiz.git
cd dotfiles_wiz

# Point to their own repo
./install.sh --repo https://github.com/them/their-dotfiles.git
```

### Example 3: ADLee Using Personal Dotfiles

```bash
# Clone dotfiles_wiz
git clone https://github.com/adlee-was-taken/dotfiles_wiz.git
cd dotfiles_wiz

# Use personal private repo
./install.sh --repo https://github.com/adlee-was-taken/dotfiles.git
```

---

## 🔒 Privacy & Security

### dotfiles_wiz (Public)
- ✅ Safe to share publicly
- ✅ Contains no private data
- ✅ Generic configurations
- ✅ Templates for everyone

### dotfiles (Personal)
- ⚠️ May contain private data
- ⚠️ SSH keys, API tokens
- ⚠️ Personal email/name
- ⚠️ Company-specific configs

**Important:** Never push private data to public repos!

---

## 📝 For Maintainers

If you're forking dotfiles_wiz:

1. **Fork dotfiles_wiz** for the framework
2. **Keep your personal dotfiles separate** in another repo
3. **Update URLs** in dotfiles_wiz to point to your fork:
   - Change `adlee-was-taken/dotfiles_wiz` to `yourname/dotfiles_wiz`
   - Keep bundled dotfiles generic and sanitized

Example:
```bash
# Your public framework
https://github.com/yourname/dotfiles_wiz.git

# Your private dotfiles  
https://github.com/yourname/my-private-dotfiles.git
```

---

## ❓ FAQ

**Q: Which repo should I clone?**  
A: Clone `dotfiles_wiz` - it includes everything you need!

**Q: Can I use ADLee's personal dotfiles?**  
A: You can reference them, but they're configured for ADLee's setup. Better to use the bundled ones or create your own.

**Q: How do I use my existing dotfiles with dotfiles_wiz?**  
A: `./install.sh --repo https://github.com/you/your-dotfiles.git`

**Q: Can I push the bundled dotfiles to my own repo?**  
A: Yes! After installation:
```bash
cd ~/.dotfiles
git remote add origin https://github.com/you/dotfiles.git
git push -u origin main
```

**Q: What's the difference between the bundled dotfiles and ADLee's personal ones?**  
A: Bundled = generic templates. Personal = ADLee's actual configurations with personal data.

---

## 📚 Related Documentation

- [README.md](README.md) - Main project documentation
- [QUICKSTART.md](QUICKSTART.md) - Quick getting started
- [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md) - Detailed installation
- [DEPLOYMENT_GUIDE.md](../DEPLOYMENT_GUIDE.md) - How to deploy your own

---

**TL;DR:**
- **dotfiles_wiz** = Framework everyone uses (clone this!)
- **dotfiles** = ADLee's personal configs (optional reference)
