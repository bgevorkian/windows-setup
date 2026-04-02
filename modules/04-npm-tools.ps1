# Module: NPM Tools (Claude Code MCP servers)
Write-Host "  --- NPM Tools (MCP servers) ---" -ForegroundColor Cyan

# Add common Node.js paths in case winget PATH hasn't propagated yet
$env:PATH = "$env:PROGRAMFILES\nodejs;$env:APPDATA\npm;$env:PATH"

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
