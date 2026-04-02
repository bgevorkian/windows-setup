# Windows Setup

One-click modular installer for a fresh Windows machine. Installs apps, configures terminal, sets up Claude Code.

## Quick Start

```powershell
# Clone and run (as Administrator)
git clone https://github.com/bgevorkian/windows-setup.git
cd windows-setup
.\setup.bat
```

After setup, sync secrets:
```powershell
pwsh -File setup-secrets.ps1
```

## Structure

```
├── setup.bat              # Main entry point — runs all modules in order
├── setup-secrets.ps1      # Syncs env variables from GitHub Variables
├── cli-tools-guide.md     # Reference guide for all CLI tools
└── modules/
    ├── 01-core-apps.bat       # Essential system apps
    ├── 02-dev-tools.bat       # Development tools
    ├── 03-terminal-tools.bat  # Terminal enhancements
    ├── 04-npm-tools.bat       # Node.js global packages (MCP servers)
    ├── 05-git-config.bat      # Git global configuration
    ├── 06-powershell-profile.bat  # PowerShell profile with aliases
    ├── 07-windows-terminal.bat    # Windows Terminal theme & settings
    └── 08-claude-config.bat       # Claude Code skills, commands, MCP
```

Each module is independent — run `setup.bat` for everything, or run any module individually.

---

## Modules

### 01 — Core Apps

Essential applications for daily use.

| App | Package ID | Description |
|-----|-----------|-------------|
| **PowerShell 7** | `Microsoft.PowerShell` | Modern cross-platform shell, replaces Windows PowerShell 5.1 |
| **Git** | `Git.Git` | Distributed version control system |
| **GitHub CLI** | `GitHub.cli` | GitHub from the command line — PRs, issues, repos, actions |
| **Node.js LTS** | `OpenJS.NodeJS.LTS` | JavaScript runtime, provides npm for global packages |
| **7-Zip** | `7zip.7zip` | File archiver — zip, 7z, tar, gz, rar |
| **Tailscale** | `Tailscale.Tailscale` | Zero-config mesh VPN for secure network access |
| **Bitwarden** | `Bitwarden.Bitwarden` | Open-source password manager |
| **Telegram** | `Telegram.TelegramDesktop` | Messaging app |
| **WinToys** | `wintoys` | Windows tweaks, cleanup, optimization GUI |
| **WSL** | `wsl --install` | Windows Subsystem for Linux |

### 02 — Dev Tools

Development environment.

| App | Package ID | Description |
|-----|-----------|-------------|
| **Terraform** | `Hashicorp.Terraform` | Infrastructure as Code — provision cloud resources declaratively |
| **Make** | `GnuWin32.Make` | Build automation tool, runs Makefiles |
| **Zed** | `ZedIndustries.Zed` | Fast GPU-accelerated code editor from the creators of Atom |
| **Python** | `Python.Python.3.14` | Python interpreter and pip package manager |
| **Claude Code** | `Anthropic.ClaudeCode` | AI coding assistant CLI from Anthropic |

### 03 — Terminal Tools

CLI replacements for standard Unix tools — faster, prettier, smarter.

| App | Package ID | Replaces | Description |
|-----|-----------|----------|-------------|
| **JetBrains Mono NF** | `DEVCOM.JetBrainsMonoNerdFont` | — | Monospace font with ligatures and icons for terminal |
| **Oh My Posh** | `JanDeDobbeleer.OhMyPosh` | — | Beautiful shell prompt with git status, execution time, errors |
| **zoxide** | `ajeetdsouza.zoxide` | `cd` | Smart directory jumper — learns your frequent paths |
| **eza** | `eza-community.eza` | `ls` | Modern ls with icons, colors, git status, tree view |
| **fzf** | `junegunn.fzf` | — | Fuzzy finder — interactive filter for any list (files, history, branches) |
| **bat** | `sharkdp.bat` | `cat` | Cat with syntax highlighting, line numbers, git integration |
| **fd** | `sharkdp.fd` | `find` | Fast file finder, respects .gitignore |
| **ripgrep** | `BurntSushi.ripgrep.MSVC` | `grep` | Fast content search, respects .gitignore |
| **btop** | `aristocratos.btop4win` | Task Manager | Beautiful TUI system monitor — CPU, RAM, disk, network |
| **dust** | `bootandy.dust` | `du` | Disk usage visualization with progress bars |
| **tokei** | `XAMPPRocky.tokei` | `wc -l` | Code statistics — lines per language |
| **lazygit** | `JesseDuffield.lazygit` | `git` TUI | Full git interface in terminal — stage, commit, push, rebase |
| **delta** | `dandavison.delta` | `diff` | Beautiful side-by-side git diffs with syntax highlighting |
| **yazi** | `sxyazi.yazi` | Explorer | Terminal file manager with preview |
| **glow** | `charmbracelet.glow` | — | Markdown renderer for terminal |
| **Neovim** | `Neovim.Neovim` | `vim` | Hyperextensible text editor |

### 04 — NPM Tools

Global Node.js packages for Claude Code MCP servers.

| Package | Description |
|---------|-------------|
| **@sarmadparvez/postgresql-mcp** | PostgreSQL MCP server — query, execute, schema, transactions |
| **@iforge.it/mssql-mcp** | MSSQL MCP server — execute SQL queries |

### 05 — Git Config

Global git settings for delta integration.

| Setting | Value | Description |
|---------|-------|-------------|
| `core.pager` | `delta` | Use delta for all git output |
| `delta.side-by-side` | `true` | Side-by-side diff view |
| `delta.line-numbers` | `true` | Show line numbers |
| `delta.navigate` | `true` | Use n/N to jump between files |
| `merge.conflictstyle` | `diff3` | Show base version in conflicts |

### 06 — PowerShell Profile

Creates `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` with:

| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons` | Beautiful file listing |
| `ll` | `eza --icons --long --git` | Detailed listing with git status |
| `lt` | `eza --icons --tree` | Tree view |
| `cat` | `bat --style=auto` | Syntax-highlighted file viewer |
| `lg` | `lazygit` | Git TUI |
| `vim` / `vi` | `nvim` | Neovim |
| `gs` | `git status` | Quick git status |
| `glog` | `git log --oneline -20` | Recent commits |
| `ep` | `notepad $PROFILE` | Edit profile |
| `reload` | `. $PROFILE` | Reload profile |
| `mcp-link` | Copy `~/.claude/mcp.json` → `.mcp.json` | Deploy MCP config to current project |

Also configures: Oh My Posh (Catppuccin Mocha), zoxide, fzf colors, PageUp/PageDown history search.

### 07 — Windows Terminal

Configures Windows Terminal with:
- **Theme:** Catppuccin Mocha
- **Font:** JetBrains Mono Nerd Font, size 11
- **Opacity:** 95%
- **Default profile:** PowerShell 7

### 08 — Claude Code Config

Clones [claude-config](https://github.com/bgevorkian/claude-config) repo and installs:
- `CLAUDE.md` — global AI instructions
- `settings.json` — permissions and preferences
- `commands/` — custom slash commands (deep-review)
- `skills/` — bi-integration, notebooklm, youtrack-create-issue
- `mcp.json` — MCP server template (use `mcp-link` to deploy)

---

## Secrets Management

Secrets are stored as [GitHub Variables](https://docs.github.com/en/actions/learn-github-actions/variables) in this repo (private, readable via `gh`).

### First-time setup (store secrets):
```powershell
gh variable set LDAP_PASSWD --body "your-password" --repo bgevorkian/windows-setup
gh variable set YOUTRACK_TOKEN --body "your-token" --repo bgevorkian/windows-setup
gh variable set MEMORYGRAPH_AUTH --body "your-base64" --repo bgevorkian/windows-setup
```

### On any new machine (pull secrets):
```powershell
pwsh -File setup-secrets.ps1
```

| Variable | Used by | Description |
|----------|---------|-------------|
| `LDAP_PASSWD` | pg-*, mssql MCP servers | LDAP password for database auth |
| `YOUTRACK_TOKEN` | YouTrack MCP | API bearer token |
| `MEMORYGRAPH_AUTH` | MemoryGraph MCP | Basic auth header (base64) |
