# Windows Setup — modular installer
# Each module runs as a separate powershell.exe that refreshes PATH from registry.
# All output stays in the current console window.
#
# Usage:
#   cd ~; irm https://github.com/bgevorkian/windows-setup/archive/main.zip -OutFile setup.zip; Expand-Archive setup.zip . -Force; powershell -ExecutionPolicy Bypass -File .\windows-setup-main\setup.ps1

$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { $PWD.Path }
$ModulesDir = Join-Path $ScriptDir "modules"

# Each module runs in a new powershell.exe that:
# 1. Refreshes PATH from registry (sees newly installed tools)
# 2. Runs in -NoNewWindow so output stays in current console
function Run-Module($name) {
    $path = Join-Path $ModulesDir "$name.ps1"
    if (-not (Test-Path $path)) {
        Write-Host "  [ERROR] $name.ps1 not found" -ForegroundColor Red
        return
    }
    $refreshAndRun = "& { `$env:PATH = [System.Environment]::GetEnvironmentVariable('PATH','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('PATH','User'); & '$path' }"
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$refreshAndRun`"" -Wait -NoNewWindow
}

Write-Host ""
Write-Host "  ========================================" -ForegroundColor Magenta
Write-Host "   Windows Fresh Setup" -ForegroundColor Magenta
Write-Host "  ========================================" -ForegroundColor Magenta
Write-Host ""

# Step 0: winget (in subprocess so its exit doesn't kill us)
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "  [0] Installing winget..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1 | iex`"" -Wait -NoNewWindow
    Write-Host ""
}

Run-Module "01-core-apps"
Run-Module "02-dev-tools"
Run-Module "03-terminal-tools"
Run-Module "04-npm-tools"
Run-Module "05-git-config"
Run-Module "06-powershell-profile"
Run-Module "07-windows-terminal"
Run-Module "08-claude-config"

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
