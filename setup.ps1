# Windows Setup — modular installer
# Each module runs as a fresh PowerShell subprocess with up-to-date PATH.
#
# Usage (one-liner, run as Admin):
#   cd ~; irm https://github.com/bgevorkian/windows-setup/archive/main.zip -OutFile setup.zip; Expand-Archive setup.zip . -Force; .\windows-setup-main\setup.ps1

$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

Write-Host ""
Write-Host "  ========================================" -ForegroundColor Magenta
Write-Host "   Windows Fresh Setup" -ForegroundColor Magenta
Write-Host "  ========================================" -ForegroundColor Magenta
Write-Host ""

# Determine script directory
$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { $PWD.Path }
$ModulesDir = Join-Path $ScriptDir "modules"

# =====================================================================
# Step 0: Ensure winget is available
# =====================================================================
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "  [0] Installing winget..." -ForegroundColor Yellow
    irm https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1 | iex
    Write-Host ""
}

# =====================================================================
# Run module in a fresh PowerShell process (inherits updated PATH)
# =====================================================================
function Run-Module($name) {
    $path = Join-Path $ModulesDir "$name.ps1"
    if (-not (Test-Path $path)) {
        Write-Host "  [ERROR] Module not found: $path" -ForegroundColor Red
        return
    }
    # Start-Process with -Wait launches a new powershell.exe that reads
    # Machine/User PATH from the registry at startup — so anything
    # installed by a previous module is immediately visible.
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$path`"" -Wait -NoNewWindow
}

# =====================================================================
# Phase 1: winget installs (core + dev + terminal)
# Each module is a subprocess, so git/node/npm installed in 01
# are visible to 04 (npm tools) and 08 (git clone).
# =====================================================================
Run-Module "01-core-apps"
Run-Module "02-dev-tools"
Run-Module "03-terminal-tools"

# =====================================================================
# Phase 2: tools that depend on git/node from Phase 1
# =====================================================================
Run-Module "04-npm-tools"
Run-Module "05-git-config"

# =====================================================================
# Phase 3: configuration
# =====================================================================
Run-Module "06-powershell-profile"
Run-Module "07-windows-terminal"
Run-Module "08-claude-config"

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
Read-Host "  Press Enter to exit"
