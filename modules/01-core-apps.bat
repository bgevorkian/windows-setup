@echo off
echo.
echo  --- Core Apps ---
echo.

winget install Microsoft.PowerShell --accept-source-agreements --accept-package-agreements
winget install Git.Git --accept-source-agreements --accept-package-agreements
winget install GitHub.cli --accept-source-agreements --accept-package-agreements
winget install OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements
winget install 7zip.7zip --accept-source-agreements --accept-package-agreements
winget install Tailscale.Tailscale --accept-source-agreements --accept-package-agreements
winget install Bitwarden.Bitwarden --accept-source-agreements --accept-package-agreements
winget install Telegram.TelegramDesktop --accept-source-agreements --accept-package-agreements
winget install wintoys --accept-source-agreements --accept-package-agreements
wsl --install --no-launch
