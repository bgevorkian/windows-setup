# Module: Windows Terminal (Catppuccin Mocha)
Write-Host "  --- Windows Terminal ---" -ForegroundColor Cyan

$wtDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (-not (Test-Path $wtDir)) {
    Write-Host "  [SKIP] Windows Terminal not found" -ForegroundColor Yellow
    exit 0
}

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
