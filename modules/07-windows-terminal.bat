@echo off
echo.
echo  --- Windows Terminal ---
echo.

set "WT_DIR=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

if not exist "%WT_DIR%" (
    echo [WARNING] Windows Terminal not found. Install from Microsoft Store, launch once, then re-run.
    exit /b 0
)

set "WT_FILE=%WT_DIR%\settings.json"

if exist "%WT_FILE%" (
    copy "%WT_FILE%" "%WT_FILE%.backup.%date:~-4,4%%date:~-7,2%%date:~-10,2%" >nul
    echo Existing settings backed up.
)

(
echo {
echo     "$help": "https://aka.ms/terminal-documentation",
echo     "$schema": "https://aka.ms/terminal-profiles-schema",
echo     "actions": [],
echo     "copyFormatting": "none",
echo     "copyOnSelect": false,
echo     "defaultProfile": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
echo     "keybindings":
echo     [
echo         { "id": "Terminal.CopyToClipboard", "keys": "ctrl+c" },
echo         { "id": "Terminal.PasteFromClipboard", "keys": "ctrl+v" },
echo         { "id": "Terminal.DuplicatePaneAuto", "keys": "alt+shift+d" }
echo     ],
echo     "newTabMenu": [ { "type": "remainingProfiles" } ],
echo     "profiles":
echo     {
echo         "defaults":
echo         {
echo             "colorScheme": "Catppuccin Mocha",
echo             "font": { "face": "JetBrainsMono Nerd Font", "size": 11 },
echo             "opacity": 95,
echo             "padding": "8",
echo             "cursorShape": "bar"
echo         },
echo         "list":
echo         [
echo             {
echo                 "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
echo                 "hidden": false,
echo                 "name": "PowerShell",
echo                 "source": "Windows.Terminal.PowershellCore"
echo             },
echo             {
echo                 "commandline": "%%SystemRoot%%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
echo                 "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
echo                 "hidden": false,
echo                 "name": "Windows PowerShell"
echo             },
echo             {
echo                 "commandline": "%%SystemRoot%%\\System32\\cmd.exe",
echo                 "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
echo                 "hidden": false,
echo                 "name": "Command Prompt"
echo             }
echo         ]
echo     },
echo     "schemes":
echo     [
echo         {
echo             "name": "Catppuccin Mocha",
echo             "cursorColor": "#F5E0DC",
echo             "selectionBackground": "#585B70",
echo             "background": "#1E1E2E",
echo             "foreground": "#CDD6F4",
echo             "black": "#45475A",
echo             "red": "#F38BA8",
echo             "green": "#A6E3A1",
echo             "yellow": "#F9E2AF",
echo             "blue": "#89B4FA",
echo             "purple": "#F5C2E7",
echo             "cyan": "#94E2D5",
echo             "white": "#BAC2DE",
echo             "brightBlack": "#585B70",
echo             "brightRed": "#F38BA8",
echo             "brightGreen": "#A6E3A1",
echo             "brightYellow": "#F9E2AF",
echo             "brightBlue": "#89B4FA",
echo             "brightPurple": "#F5C2E7",
echo             "brightCyan": "#94E2D5",
echo             "brightWhite": "#A6ADC8"
echo         }
echo     ],
echo     "themes": []
echo }
) > "%WT_FILE%"

echo Windows Terminal configured.
