# Module: Core Apps
Write-Host "  --- Core Apps ---" -ForegroundColor Cyan

function Install-App($id, $name) {
    Write-Host "  $name... " -NoNewline
    $result = winget install $id --accept-source-agreements --accept-package-agreements --silent 2>&1
    if ($result -match "already installed") {
        Write-Host "already installed" -ForegroundColor DarkGray
    } else {
        Write-Host "done" -ForegroundColor Green
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

Write-Host "  WSL... " -NoNewline
wsl --install --no-launch 2>$null
Write-Host "done" -ForegroundColor Green
