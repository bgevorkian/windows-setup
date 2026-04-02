# Windows Setup

One-click installer for a fresh Windows machine. Installs apps, configures terminal, sets up Claude Code.

## Quick Start

One-liner in PowerShell (run as Administrator):
```powershell
cd ~; irm https://raw.githubusercontent.com/bgevorkian/windows-setup/main/setup.ps1 -OutFile setup.ps1; powershell -ExecutionPolicy Bypass -File setup.ps1
```

Or download ZIP and run:
```powershell
cd ~; irm https://github.com/bgevorkian/windows-setup/archive/main.zip -OutFile setup.zip; Expand-Archive setup.zip . -Force; .\windows-setup-main\setup.bat
```

After setup, sync secrets:
```powershell
pwsh -File setup-secrets.ps1
```

## Structure

```
├── setup.ps1              # Main installer (PowerShell)
├── setup.bat              # Wrapper for setup.ps1
├── setup-secrets.ps1      # Syncs env variables from GitHub Variables
├── cli-tools-guide.md     # Reference guide for all CLI tools
└── README.md
```

## What Gets Installed

### Phase 1 -- Core Apps

| App | Package ID | Description |
|-----|-----------|-------------|
| **PowerShell 7** | `Microsoft.PowerShell` | Modern cross-platform shell |
| **Git** | `Git.Git` | Distributed version control |
| **GitHub CLI** | `GitHub.cli` | GitHub from the command line |
| **Node.js LTS** | `OpenJS.NodeJS.LTS` | JavaScript runtime, provides npm |
| **7-Zip** | `7zip.7zip` | File archiver |
| **Tailscale** | `Tailscale.Tailscale` | Zero-config mesh VPN |
| **Bitwarden** | `Bitwarden.Bitwarden` | Password manager |
| **Telegram** | `Telegram.TelegramDesktop` | Messaging app |
| **WinToys** | `wintoys` | Windows optimization GUI |
| **WSL** | `wsl --install` | Windows Subsystem for Linux |

### Phase 2 -- Dev Tools

| App | Package ID | Description |
|-----|-----------|-------------|
| **Terraform** | `Hashicorp.Terraform` | Infrastructure as Code |
| **Make** | `GnuWin32.Make` | Build automation |
| **Zed** | `ZedIndustries.Zed` | GPU-accelerated code editor |
| **Python** | `Python.Python.3.14` | Python interpreter |
| **Claude Code** | `Anthropic.ClaudeCode` | AI coding assistant CLI |

### Phase 3 -- Terminal Tools

| App | Package ID | Replaces | Description |
|-----|-----------|----------|-------------|
| **JetBrains Mono NF** | `DEVCOM.JetBrainsMonoNerdFont` | -- | Monospace font with icons |
| **Oh My Posh** | `JanDeDobbeleer.OhMyPosh` | -- | Beautiful shell prompt |
| **zoxide** | `ajeetdsouza.zoxide` | `cd` | Smart directory jumper |
| **eza** | `eza-community.eza` | `ls` | Modern ls with icons, colors, git |
| **fzf** | `junegunn.fzf` | -- | Fuzzy finder |
| **bat** | `sharkdp.bat` | `cat` | Cat with syntax highlighting |
| **fd** | `sharkdp.fd` | `find` | Fast file finder |
| **ripgrep** | `BurntSushi.ripgrep.MSVC` | `grep` | Fast content search |
| **btop** | `aristocratos.btop4win` | Task Manager | TUI system monitor |
| **dust** | `bootandy.dust` | `du` | Disk usage visualization |
| **tokei** | `XAMPPRocky.tokei` | `wc -l` | Code statistics |
| **lazygit** | `JesseDuffield.lazygit` | `git` TUI | Git interface in terminal |
| **delta** | `dandavison.delta` | `diff` | Beautiful git diffs |
| **yazi** | `sxyazi.yazi` | Explorer | Terminal file manager |
| **glow** | `charmbracelet.glow` | -- | Markdown renderer |
| **Neovim** | `Neovim.Neovim` | `vim` | Hyperextensible text editor |

### Phase 4 -- NPM Tools

| Package | Description |
|---------|-------------|
| **@sarmadparvez/postgresql-mcp** | PostgreSQL MCP server for Claude Code |
| **@iforge.it/mssql-mcp** | MSSQL MCP server for Claude Code |

### Phase 5 -- Git Config

Delta integration: side-by-side diffs, line numbers, navigation.

### Phase 6 -- PowerShell Profile

| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons` | Beautiful file listing |
| `ll` | `eza --icons --long --git` | Detailed listing |
| `lt` | `eza --icons --tree` | Tree view |
| `cat` | `bat --style=auto` | Syntax-highlighted viewer |
| `lg` | `lazygit` | Git TUI |
| `vim`/`vi` | `nvim` | Neovim |
| `gs` | `git status` | Quick git status |
| `glog` | `git log --oneline -20` | Recent commits |
| `ep` | `notepad $PROFILE` | Edit profile |
| `reload` | `. $PROFILE` | Reload profile |
| `mcp-link` | Copy MCP config | Deploy `~/.claude/mcp.json` to `.mcp.json` |

Plus: Oh My Posh (Catppuccin Mocha), zoxide, fzf, PageUp/PageDown history search.

### Phase 7 -- Windows Terminal

Catppuccin Mocha theme, JetBrains Mono Nerd Font, PowerShell 7 as default.

### Phase 8 -- Claude Code Config

Clones [claude-config](https://github.com/bgevorkian/claude-config) and installs skills, commands, settings, MCP template.

## Secrets Management

Secrets stored as [GitHub Variables](https://docs.github.com/en/actions/learn-github-actions/variables) (private, readable only by repo owner).

### Store (first time):
```powershell
gh variable set LDAP_PASSWD --body "value" --repo bgevorkian/windows-setup
gh variable set YOUTRACK_TOKEN --body "value" --repo bgevorkian/windows-setup
gh variable set MEMORYGRAPH_AUTH --body "value" --repo bgevorkian/windows-setup
```

### Pull (any new machine):
```powershell
pwsh -File setup-secrets.ps1
```

| Variable | Used by | Description |
|----------|---------|-------------|
| `LDAP_PASSWD` | pg-*, mssql MCP | LDAP password for database auth |
| `YOUTRACK_TOKEN` | YouTrack MCP | API bearer token |
| `MEMORYGRAPH_AUTH` | MemoryGraph MCP | Basic auth (base64) |
