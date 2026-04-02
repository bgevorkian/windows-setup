#Requires -RunAsAdministrator
# Windows Setup — modular one-click installer
# Usage: cd ~; irm https://raw.githubusercontent.com/bgevorkian/windows-setup/main/setup.ps1 | iex

$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

function Refresh-Path {
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User") + ";$env:LOCALAPPDATA\Microsoft\WindowsApps;$env:PROGRAMFILES\WinGet\Links;$env:PROGRAMFILES\nodejs;$env:APPDATA\npm;$env:PROGRAMFILES\Git\cmd"
}

function Write-Step($text) {
    Write-Host "`n  --- $text ---`n" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "  ========================================" -ForegroundColor Magenta
Write-Host "   Windows Fresh Setup" -ForegroundColor Magenta
Write-Host "  ========================================" -ForegroundColor Magenta
Write-Host ""

# Determine script directory (for module imports)
$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { $PWD.Path }
$ModulesDir = Join-Path $ScriptDir "modules"

# =====================================================================
# Phase 0: winget
# =====================================================================
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Step "Installing winget"
    irm https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1 | iex
    Refresh-Path
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "[ERROR] Failed to install winget." -ForegroundColor Red
        exit 1
    }
}
Write-Host "  winget OK" -ForegroundColor Green

# =====================================================================
# Helper: install via winget (skip if already installed)
# =====================================================================
function Install-App($id, $name) {
    Write-Host "  $name... " -NoNewline
    $result = winget install $id --accept-source-agreements --accept-package-agreements --silent 2>&1
    if ($result -match "already installed") {
        Write-Host "already installed" -ForegroundColor DarkGray
    } else {
        Write-Host "done" -ForegroundColor Green
    }
}

# =====================================================================
# Phase 1: Core Apps
# =====================================================================
Write-Step "Core Apps"
Install-App "Microsoft.PowerShell"         "PowerShell 7"
Install-App "Git.Git"                      "Git"
Install-App "GitHub.cli"                   "GitHub CLI"
Install-App "OpenJS.NodeJS.LTS"            "Node.js LTS"
Install-App "7zip.7zip"                    "7-Zip"
Install-App "Tailscale.Tailscale"          "Tailscale"
Install-App "Bitwarden.Bitwarden"          "Bitwarden"
Install-App "Telegram.TelegramDesktop"     "Telegram"
Install-App "wintoys"                      "WinToys"
Write-Host "  WSL... " -NoNewline
wsl --install --no-launch 2>$null
Write-Host "done" -ForegroundColor Green
Refresh-Path

# =====================================================================
# Phase 2: Dev Tools
# =====================================================================
Write-Step "Dev Tools"
Install-App "Hashicorp.Terraform"          "Terraform"
Install-App "GnuWin32.Make"                "Make"
Install-App "ZedIndustries.Zed"            "Zed"
Install-App "Python.Python.3.14"           "Python"
Install-App "Anthropic.ClaudeCode"         "Claude Code"
Refresh-Path

# =====================================================================
# Phase 3: Terminal Tools
# =====================================================================
Write-Step "Terminal Tools"
Install-App "DEVCOM.JetBrainsMonoNerdFont"  "JetBrains Mono Nerd Font"
Install-App "JanDeDobbeleer.OhMyPosh"       "Oh My Posh"
Install-App "ajeetdsouza.zoxide"            "zoxide"
Install-App "eza-community.eza"             "eza"
Install-App "junegunn.fzf"                  "fzf"
Install-App "sharkdp.bat"                   "bat"
Install-App "sharkdp.fd"                    "fd"
Install-App "BurntSushi.ripgrep.MSVC"       "ripgrep"
Install-App "aristocratos.btop4win"         "btop"
Install-App "bootandy.dust"                 "dust"
Install-App "XAMPPRocky.tokei"              "tokei"
Install-App "JesseDuffield.lazygit"         "lazygit"
Install-App "dandavison.delta"              "delta"
Install-App "GnuWin32.File"                 "GnuWin32 File"
Install-App "sxyazi.yazi"                   "yazi"
Install-App "charmbracelet.glow"            "glow"
Install-App "Neovim.Neovim"                 "Neovim"
Refresh-Path

# =====================================================================
# Phase 4: NPM Tools (Claude Code MCP servers)
# =====================================================================
Write-Step "NPM Tools (MCP servers)"
if (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Host "  postgresql-mcp... " -NoNewline
    npm install -g "@sarmadparvez/postgresql-mcp" 2>$null | Out-Null
    Write-Host "done" -ForegroundColor Green
    Write-Host "  mssql-mcp... " -NoNewline
    npm install -g "@iforge.it/mssql-mcp" 2>$null | Out-Null
    Write-Host "done" -ForegroundColor Green
} else {
    Write-Host "  [SKIP] npm not found -- restart terminal and run this phase again" -ForegroundColor Yellow
}

# =====================================================================
# Phase 5: Git Config
# =====================================================================
Write-Step "Git Config"
if (Get-Command git -ErrorAction SilentlyContinue) {
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.side-by-side true
    git config --global delta.line-numbers true
    git config --global merge.conflictstyle diff3
    Write-Host "  Git configured with delta" -ForegroundColor Green
} else {
    Write-Host "  [SKIP] git not found" -ForegroundColor Yellow
}

# =====================================================================
# Phase 6: PowerShell Profile
# =====================================================================
Write-Step "PowerShell Profile"

$profileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }

if (Test-Path $PROFILE) {
    $backup = "$PROFILE.backup.$(Get-Date -Format 'yyyyMMdd')"
    Copy-Item $PROFILE $backup -Force
    Write-Host "  Existing profile backed up to $backup" -ForegroundColor DarkGray
}

@'
# PowerShell Profile -- auto-generated by windows-setup

# ========== STARTUP DIRECTORY ==========
Set-Location $env:USERPROFILE

# ========== MODERN CLI ALIASES ==========

# eza (beautiful ls with icons)
function List-Pretty { eza --icons --group-directories-first @args }
function List-Long { eza --icons --long --group-directories-first --git @args }
function List-Tree { eza --icons --tree --level=2 --group-directories-first @args }
Set-Alias -Name ls -Value List-Pretty -Option AllScope -Force
Set-Alias -Name ll -Value List-Long
Set-Alias -Name lt -Value List-Tree

# bat (cat with syntax highlighting)
function Read-Pretty { bat --style=auto @args }
Set-Alias -Name cat -Value Read-Pretty -Option AllScope -Force

# Common shortcuts
Set-Alias -Name which -Value Get-Command
Set-Alias -Name lg -Value lazygit
Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim

# Git shortcuts
function Git-Status { git status }
function Git-LogShort { git log --oneline -20 }
Set-Alias -Name gs -Value Git-Status
Set-Alias -Name glog -Value Git-LogShort

# Quick edit and reload profile
function Edit-Profile { notepad $PROFILE }
function Reload-Profile { . $PROFILE; Write-Host "Profile reloaded" -ForegroundColor Green }
Set-Alias -Name ep -Value Edit-Profile
Set-Alias -Name reload -Value Reload-Profile

# ========== CLAUDE CODE ==========
function Copy-McpConfig {
    $src = "$env:USERPROFILE\.claude\mcp.json"
    if (Test-Path $src) {
        Copy-Item $src -Destination ".mcp.json" -Force
        Write-Host "MCP config copied from $src" -ForegroundColor Green
    } else {
        Write-Host "MCP config not found at $src" -ForegroundColor Red
    }
}
Set-Alias -Name mcp-link -Value Copy-McpConfig

# ========== FZF (Catppuccin Mocha colors) ==========
$env:FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# ========== PATH (GnuWin32 for yazi file detection) ==========
$env:PATH = "C:\Program Files (x86)\GnuWin32\bin;$env:PATH"

# ========== OH MY POSH ==========
$poshTheme = if ($env:POSH_THEMES_PATH) {
    "$env:POSH_THEMES_PATH\catppuccin_mocha.omp.json"
} else {
    $appxPath = (Get-AppxPackage -Name 'ohmyposh.cli' -ErrorAction SilentlyContinue | Select-Object -First 1).InstallLocation
    if ($appxPath) { Join-Path $appxPath 'themes\catppuccin_mocha.omp.json' }
}
if ($poshTheme -and (Test-Path $poshTheme)) {
    oh-my-posh init pwsh --config $poshTheme | Invoke-Expression
} else {
    Write-Host "Oh My Posh theme not found" -ForegroundColor Yellow
}

# ========== ZOXIDE (smart cd) ==========
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# ========== HISTORY SEARCH ==========
Set-PSReadLineKeyHandler -Key PageUp -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key PageDown -Function HistorySearchForward

# ========== STARTUP MESSAGE ==========
Write-Host "Terminal ready." -ForegroundColor DarkGray
'@ | Set-Content -Path $PROFILE -Encoding UTF8

Write-Host "  Profile created at $PROFILE" -ForegroundColor Green

# =====================================================================
# Phase 7: Windows Terminal
# =====================================================================
Write-Step "Windows Terminal"

$wtDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (-not (Test-Path $wtDir)) {
    Write-Host "  [SKIP] Windows Terminal not found" -ForegroundColor Yellow
} else {
    $wtFile = Join-Path $wtDir "settings.json"
    if (Test-Path $wtFile) {
        Copy-Item $wtFile "$wtFile.backup.$(Get-Date -Format 'yyyyMMdd')" -Force
    }
    @'
{
    "$help": "https://aka.ms/terminal-documentation",
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "actions": [],
    "copyFormatting": "none",
    "copyOnSelect": false,
    "defaultProfile": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
    "keybindings": [
        { "id": "Terminal.CopyToClipboard", "keys": "ctrl+c" },
        { "id": "Terminal.PasteFromClipboard", "keys": "ctrl+v" },
        { "id": "Terminal.DuplicatePaneAuto", "keys": "alt+shift+d" }
    ],
    "newTabMenu": [ { "type": "remainingProfiles" } ],
    "profiles": {
        "defaults": {
            "colorScheme": "Catppuccin Mocha",
            "font": { "face": "JetBrainsMono Nerd Font", "size": 11 },
            "opacity": 95,
            "padding": "8",
            "cursorShape": "bar"
        },
        "list": [
            { "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}", "hidden": false, "name": "PowerShell", "source": "Windows.Terminal.PowershellCore" },
            { "commandline": "%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe", "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}", "hidden": false, "name": "Windows PowerShell" },
            { "commandline": "%SystemRoot%\\System32\\cmd.exe", "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}", "hidden": false, "name": "Command Prompt" }
        ]
    },
    "schemes": [
        {
            "name": "Catppuccin Mocha",
            "cursorColor": "#F5E0DC", "selectionBackground": "#585B70",
            "background": "#1E1E2E", "foreground": "#CDD6F4",
            "black": "#45475A", "red": "#F38BA8", "green": "#A6E3A1", "yellow": "#F9E2AF",
            "blue": "#89B4FA", "purple": "#F5C2E7", "cyan": "#94E2D5", "white": "#BAC2DE",
            "brightBlack": "#585B70", "brightRed": "#F38BA8", "brightGreen": "#A6E3A1", "brightYellow": "#F9E2AF",
            "brightBlue": "#89B4FA", "brightPurple": "#F5C2E7", "brightCyan": "#94E2D5", "brightWhite": "#A6ADC8"
        }
    ],
    "themes": []
}
'@ | Set-Content -Path $wtFile -Encoding UTF8
    Write-Host "  Windows Terminal configured" -ForegroundColor Green
}

# =====================================================================
# Phase 8: Claude Code Config
# =====================================================================
Write-Step "Claude Code Config"

$claudeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null }

$tempClone = "$env:TEMP\claude-config-clone"
if (Test-Path $tempClone) { Remove-Item $tempClone -Recurse -Force }

if (Get-Command git -ErrorAction SilentlyContinue) {
    git clone https://github.com/bgevorkian/claude-config.git $tempClone 2>$null

    if (Test-Path "$tempClone\CLAUDE.md") {
        Copy-Item "$tempClone\CLAUDE.md" "$claudeDir\CLAUDE.md" -Force
        Write-Host "  CLAUDE.md" -ForegroundColor Green
        Copy-Item "$tempClone\settings.json" "$claudeDir\settings.json" -Force
        Write-Host "  settings.json" -ForegroundColor Green
        Copy-Item "$tempClone\commands" "$claudeDir\commands" -Recurse -Force
        Write-Host "  commands/" -ForegroundColor Green
        Copy-Item "$tempClone\skills" "$claudeDir\skills" -Recurse -Force
        Write-Host "  skills/" -ForegroundColor Green
        Copy-Item "$tempClone\mcp\prefectum.mcp.json" "$claudeDir\mcp.json" -Force
        Write-Host "  mcp.json (template)" -ForegroundColor Green
        Remove-Item $tempClone -Recurse -Force
    } else {
        Write-Host "  [ERROR] Failed to clone claude-config" -ForegroundColor Red
    }
} else {
    Write-Host "  [SKIP] git not found" -ForegroundColor Yellow
}

# =====================================================================
# Done
# =====================================================================
Write-Host ""
Write-Host "  ========================================" -ForegroundColor Green
Write-Host "   Setup complete!" -ForegroundColor Green
Write-Host "  ========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  To sync secrets:  pwsh -File setup-secrets.ps1" -ForegroundColor DarkGray
Write-Host "  MCP in projects:  mcp-link" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Close this window, open Windows Terminal." -ForegroundColor Yellow
Write-Host ""
