# Module: Core Apps
Write-Host "  --- Core Apps ---" -ForegroundColor Cyan

function Install-App($id, $name) {
    Write-Host ""
    Write-Host "  [$name] winget install $id" -ForegroundColor White
    winget install $id --source winget --accept-source-agreements --accept-package-agreements --silent
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [$name] OK" -ForegroundColor Green
    } else {
        Write-Host "  [$name] exit code: $LASTEXITCODE" -ForegroundColor Yellow
    }
}

Install-App "Microsoft.PowerShell"         "PowerShell 7"
Install-App "Git.Git"                      "Git"
Install-App "GitHub.cli"                   "GitHub CLI"
Install-App "OpenJS.NodeJS.LTS"            "Node.js LTS"
Install-App "7zip.7zip"                    "7-Zip"
Install-App "Tailscale.Tailscale"          "Tailscale"
Install-App "Bitwarden.Bitwarden"          "Bitwarden"
Install-App "Telegram.TelegramDesktop"     "Telegram"
Install-App "wintoys"                      "WinToys"

Write-Host ""
Write-Host "  [WSL] wsl --install --no-launch" -ForegroundColor White
wsl --install --no-launch
Write-Host "  [WSL] done" -ForegroundColor Green
