# Windows Setup — two-stage installer
# Stage 1: Install apps via winget (requires restart for PATH)
# Stage 2: Configure everything (git, npm, profile, etc.)
#
# Usage:
#   cd ~; irm https://github.com/bgevorkian/windows-setup/archive/main.zip -OutFile setup.zip; Expand-Archive setup.zip . -Force; powershell -ExecutionPolicy Bypass -File .\windows-setup-main\setup.ps1

param([switch]$Stage2)

$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { $PWD.Path }
$ModulesDir = Join-Path $ScriptDir "modules"
$ScriptPath = Join-Path $ScriptDir "setup.ps1"

function Install-App($id, $name) {
    Write-Host "  $name... " -NoNewline
    $result = winget install $id --accept-source-agreements --accept-package-agreements --silent 2>&1
    if ($result -match "already installed") {
        Write-Host "already installed" -ForegroundColor DarkGray
    } else {
        Write-Host "done" -ForegroundColor Green
    }
}

if (-not $Stage2) {
    # =================================================================
    # STAGE 1: Install everything via winget
    # =================================================================
    Write-Host ""
    Write-Host "  ========================================" -ForegroundColor Magenta
    Write-Host "   Windows Fresh Setup — Stage 1" -ForegroundColor Magenta
    Write-Host "  ========================================" -ForegroundColor Magenta
    Write-Host ""

    # Ensure winget
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "  Installing winget..." -ForegroundColor Yellow
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1 | iex`"" -Wait
        # Refresh PATH after winget install
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User") + ";$env:LOCALAPPDATA\Microsoft\WindowsApps;$env:PROGRAMFILES\WinGet\Links"
    }

    Write-Host "`n  --- Core Apps ---" -ForegroundColor Cyan
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

    Write-Host "`n  --- Dev Tools ---" -ForegroundColor Cyan
    Install-App "Hashicorp.Terraform"          "Terraform"
    Install-App "GnuWin32.Make"                "Make"
    Install-App "ZedIndustries.Zed"            "Zed"
    Install-App "Python.Python.3.14"           "Python"
    Install-App "Anthropic.ClaudeCode"         "Claude Code"

    Write-Host "`n  --- Terminal Tools ---" -ForegroundColor Cyan
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

    # =================================================================
    # Launch Stage 2 in a NEW PowerShell process (fresh PATH)
    # =================================================================
    Write-Host ""
    Write-Host "  Stage 1 complete. Launching Stage 2 in new console..." -ForegroundColor Yellow
    Write-Host ""
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`" -Stage2" -Verb RunAs
    exit
}

# =====================================================================
# STAGE 2: Configure (runs in a fresh process with updated PATH)
# =====================================================================
Write-Host ""
Write-Host "  ========================================" -ForegroundColor Magenta
Write-Host "   Windows Fresh Setup — Stage 2" -ForegroundColor Magenta
Write-Host "  ========================================" -ForegroundColor Magenta
Write-Host ""

# --- NPM Tools ---
Write-Host "  --- NPM Tools (MCP servers) ---" -ForegroundColor Cyan
if (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Host "  postgresql-mcp... " -NoNewline
    npm install -g "@sarmadparvez/postgresql-mcp" 2>$null | Out-Null
    Write-Host "done" -ForegroundColor Green
    Write-Host "  mssql-mcp... " -NoNewline
    npm install -g "@iforge.it/mssql-mcp" 2>$null | Out-Null
    Write-Host "done" -ForegroundColor Green
} else {
    Write-Host "  [SKIP] npm not found" -ForegroundColor Yellow
}

# --- Git Config ---
Write-Host "`n  --- Git Config ---" -ForegroundColor Cyan
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

# --- PowerShell Profile ---
Write-Host "`n  --- PowerShell Profile ---" -ForegroundColor Cyan
& (Join-Path $ScriptDir "modules\06-powershell-profile.ps1")

# --- Windows Terminal ---
Write-Host "`n  --- Windows Terminal ---" -ForegroundColor Cyan
& (Join-Path $ScriptDir "modules\07-windows-terminal.ps1")

# --- Claude Code Config ---
Write-Host "`n  --- Claude Code Config ---" -ForegroundColor Cyan
if (Get-Command git -ErrorAction SilentlyContinue) {
    $claudeDir = "$env:USERPROFILE\.claude"
    if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null }

    $tempClone = "$env:TEMP\claude-config-clone"
    if (Test-Path $tempClone) { Remove-Item $tempClone -Recurse -Force }

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

# --- Done ---
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
Read-Host "  Press Enter to exit"
