# Module: Claude Code Config (from GitHub)
Write-Host "  --- Claude Code Config ---" -ForegroundColor Cyan

$env:PATH = "$env:PROGRAMFILES\Git\cmd;$env:PATH"

$claudeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null }

$tempClone = "$env:TEMP\claude-config-clone"
if (Test-Path $tempClone) { Remove-Item $tempClone -Recurse -Force }

if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "  Cloning claude-config..." -ForegroundColor White
    git clone https://github.com/bgevorkian/claude-config.git $tempClone

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
